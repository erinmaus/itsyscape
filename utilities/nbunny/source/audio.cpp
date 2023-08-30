////////////////////////////////////////////////////////////////////////////////
// source/audio.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <algorithm>
#include "common/math.h"
#include "nbunny/nbunny.hpp"
#include "modules/data/wrap_Data.h"
#include "modules/data/DataModule.h"

#define GET_BUFFER(BUFFER, LENGTH, INDEX) \
	float* BUFFER; \
	std::size_t LENGTH; \
	get_data(L, INDEX, BUFFER, LENGTH)

#define GET_DEFAULT_BUFFER() GET_BUFFER(buffer, length, 1)

static void get_data(lua_State* L, int index, float*& buffer, std::size_t& length)
{
	auto data = love::data::luax_checkdata(L, index);
	buffer = (float*)data->getData();
	length = data->getSize() / sizeof(float);
}

static int nbunny_audio_get_rms_volume(lua_State* L)
{
	GET_DEFAULT_BUFFER();

	float average = 0.0f;

	for (std::size_t i = 0; i < length; ++i)
	{
		average += buffer[i] * buffer[i];
	}

	lua_pushnumber(L, std::sqrt(average / (float)length));
	return 1;
}

static int nbunny_audio_normalize(lua_State* L)
{
	GET_DEFAULT_BUFFER();

	float max = 0.0f;
	for (std::size_t i = 0; i < length; ++i)
	{
		auto f = std::fabs(buffer[i]);
		max = f > max ? f : max;
	}

	if (max > 0.0f)
	{
		auto r = 1.0f / max;
		for (std::size_t i = 0; i < length; ++i)
		{
			buffer[i] *= r;
		}
	}

	return 0;
}

static int nbunny_audio_low_pass_filter(lua_State* L)
{
	GET_DEFAULT_BUFFER();
	auto sampleRate = luaL_checknumber(L, 2);
	auto cutoff = luaL_checknumber(L, 3);
	auto range = luaL_checknumber(L, 4);

	cutoff = (cutoff - range) / sampleRate;
	range = range / sampleRate;

	std::vector<float> temp;
	temp.assign(buffer, buffer + length);

	auto n = (std::size_t)std::floor(3.1f / range + 0.5f);
	if ((n + 1) % 2 == 0)
	{
		++n;
	}

	std::vector<float> b;
	b.resize(n);

	for (std::size_t i = 0; i < n; ++i)
	{
		auto x = i - (n - 1) / 2.0f;
		auto angle = 2.0f * LOVE_M_PI * cutoff * x;

		b[i] = 2.0f * cutoff * std::sin(angle) / angle;
	}

	for (int i = 0; i < length; ++i)
	{
		for (int j = 0; j < n; ++j)
		{
			if (i - j >= 0)
			{
				buffer[i] += b[j] * temp[i - j];
			}
		}
	}

	return 0;
}

static int nbunny_audio_down_sample(lua_State* L)
{
	GET_DEFAULT_BUFFER();
	auto sampleRate = luaL_checkinteger(L, 2);
	auto targetSampleRate = luaL_checkinteger(L, 3);

	love::data::ByteData* result;
	if (sampleRate <= targetSampleRate)
	{
		result = love::data::DataModule::instance.newByteData(buffer, length * sizeof(float));
	}
	else if (sampleRate % targetSampleRate == 0)
	{
		auto skip = sampleRate / targetSampleRate;

		auto n = length / skip;
		result = love::data::DataModule::instance.newByteData(n * sizeof(float));

		auto output = (float*)result->getData();
		for (std::size_t i = 0; i < n; ++i)
		{
			output[i] = buffer[i * skip];
		}
	}
	else
	{
		auto df = (float)sampleRate / (float)targetSampleRate;

		auto n = (int)std::floor(length / df + 0.5f);
		result = love::data::DataModule::instance.newByteData(n * sizeof(float));

		auto output = (float*)result->getData();
		for (std::size_t i = 0; i < n; ++i)
		{
			auto fIndex = df * i;
			auto i0 = std::floor(fIndex);
			auto i1 = std::min((std::size_t)i0, length - 1);
			auto t = fIndex - i0;
			auto x0 = buffer[(int)i0];
			auto x1 = buffer[(int)i1];

			output[i] = x1 * t + x0 * (1.0f - t);
		}
	}

	luax_pushtype(L, result);
	result->release();
	
	return 1;
}

static int nbunny_audio_pre_emphasis(lua_State* L)
{
	GET_DEFAULT_BUFFER();
	auto p = luaL_checknumber(L, 2);

	std::vector<float> temp;
	temp.assign(buffer, buffer + length);

	for (std::size_t i = 1; i < length; ++i)
	{
		buffer[i] = temp[i] - p * temp[i - 1];
	}

	return 0;
}

static int nbunny_audio_hamming_window(lua_State* L)
{
	GET_DEFAULT_BUFFER();

	std::vector<float> temp;
	temp.assign(buffer, buffer + length);

	for (std::size_t i = 0; i < length; ++i)
	{
		auto x = i / (length - 1.0f);
		buffer[i] *= 0.54f - 0.46f * std::cos(2.0f * LOVE_M_PI * x);
	}

	return 0;
}

static void do_fft(std::vector<float>& spectrumRe, std::vector<float>& spectrumIm, std::size_t N)
{
	if (N < 2)
	{
		return;
	}

	auto halfN = N / 2;
	std::vector<float> evenRe;
	evenRe.resize(halfN);
	std::vector<float> evenIm;
	evenIm.resize(halfN);
	std::vector<float> oddRe;
	oddRe.resize(halfN);
	std::vector<float> oddIm;
	oddIm.resize(halfN);

	for (std::size_t i = 0; i < halfN; ++i)
	{
		evenRe[i] = spectrumRe[i * 2];
		evenIm[i] = spectrumIm[i * 2];

		oddRe[i] = spectrumRe[i * 2 + 1];
		oddIm[i] = spectrumIm[i * 2 + 1];
	}

	do_fft(evenRe, evenIm, halfN);
	do_fft(oddRe, oddIm, halfN);

	for (std::size_t i = 0; i < halfN; ++i)
	{
		auto _er = evenRe[i];
		auto _ei = evenIm[i];
		auto _or = oddRe[i];
		auto _oi = oddIm[i];
		auto theta = -2.0 * LOVE_M_PI * i / (float)N;

		auto cx0 = std::cos(theta);
		auto cy0 = std::sin(theta);
		auto cx1 = cx0 * _or - cy0 * _oi;
		auto cy1 = cx0 * _oi + cy0 * _or;

		spectrumRe[i] = _er + cx1;
		spectrumIm[i] = _ei + cy1;
		spectrumRe[halfN + i] = _er - cx1;
		spectrumIm[halfN + i] = _ei - cy1;
	}
}

static int nbunny_audio_fft(lua_State* L)
{
	GET_DEFAULT_BUFFER();

	auto N = length;

	std::vector<float> spectrum;
	spectrum.resize(N);

	std::vector<float> spectrumRe;
	spectrumRe.resize(N);
	std::vector<float> spectrumIm;
	spectrumIm.resize(N);

	for (std::size_t i = 0; i < N; ++i)
	{
		spectrumRe[i] = buffer[i];
	}

	do_fft(spectrumRe, spectrumIm, N);

	for (std::size_t i = 0; i < N; ++i)
	{
		auto re = spectrumRe[i];
		auto im = spectrumIm[i];

		spectrum[i] = std::sqrt(re * re + im * im);
	}

	auto result = love::data::DataModule::instance.newByteData(&spectrum[0], N * sizeof(float));
	luax_pushtype(L, result);
	result->release();

	return 1;
}

static float to_mel(float hz)
{
	const float a = 1127.0f;
	return a * std::log(hz / 700.0f + 1.0f);
}

static float to_hz(float mel)
{
	const float a = 1127.0f;
	return 700.0f * (std::exp(mel / a) - 1.0f);
}

static int nbunny_audio_mel_filter_bank(lua_State* L)
{
	GET_DEFAULT_BUFFER();
	auto sampleRate = luaL_checkinteger(L, 2);
	auto melDiv = luaL_checkinteger(L, 3);

	std::vector<float> melSpectrum;
	melSpectrum.resize(melDiv);

	auto fMax = sampleRate / 2.0f;
	auto melMax = to_mel(fMax);
	auto nMax = length / 2.0f;
	auto df = fMax / nMax;
	auto dMel = melMax / (melDiv + 1.0f);

	for (std::size_t i = 0; i < melDiv; ++i)
	{
		auto melBegin = dMel * i;
		auto melCenter = dMel * (i + 1);
		auto melEnd = dMel * (i + 2);

		auto fBegin = to_hz(melBegin);
		auto fCenter = to_hz(melCenter);
		auto fEnd = to_hz(melEnd);

		auto iBegin = std::ceil(fBegin / df);
		auto iCenter = std::floor(fCenter / df + 0.5);
		auto iEnd = std::floor(fEnd / df);

		auto sum = 0.0f;
		for (std::size_t j = iBegin + 1; j < iEnd; ++j)
		{
			auto f = df * j;

			float a;
			if (j < iCenter)
			{
				a = (f - fBegin) / (fCenter - fBegin);
			}
			else
			{
				a = (fEnd - f) / (fEnd - fCenter);
			}

			a /= (fEnd - fBegin) * 0.5f;
			sum += a * buffer[j];
		}

		melSpectrum[i] = sum;
	}

	auto result = love::data::DataModule::instance.newByteData(&melSpectrum[0], melSpectrum.size() * sizeof(float));
	luax_pushtype(L, result);
	result->release();

	return 1;
}

static int nbunny_audio_power_to_db(lua_State* L)
{
	GET_DEFAULT_BUFFER();

	for (std::size_t i = 0; i < length; ++i)
	{
		buffer[i] = 10.0f * std::log10(buffer[i]);
	}

	return 0;
}

static int nbunny_audio_dct(lua_State* L)
{
	GET_DEFAULT_BUFFER();

	std::vector<float> cepstrum;
	cepstrum.resize(length);

	auto a = LOVE_M_PI / length;

	for (std::size_t i = 0; i < length; ++i)
	{
		auto sum = 0.0f;

		for (std::size_t j = 0; j < length; ++j)
		{
			auto angle = (j + 0.5f) * i * a;
			sum += buffer[j] * std::cos(angle);
		}

		cepstrum[i] = sum;
	}

	auto result = love::data::DataModule::instance.newByteData(&cepstrum[0], cepstrum.size() * sizeof(float));
	luax_pushtype(L, result);
	result->release();

	return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_audio(lua_State* L)
{
	auto T = sol::table(nbunny::get_lua_state(L), sol::create);
	T["getRMSVolume"] = &nbunny_audio_get_rms_volume;
	T["normalize"] = &nbunny_audio_normalize;
	T["lowPassFilter"] = &nbunny_audio_low_pass_filter;
	T["downSample"] = &nbunny_audio_down_sample;
	T["preEmphasis"] = &nbunny_audio_pre_emphasis;
	T["hammingWindow"] = &nbunny_audio_hamming_window;
	T["fft"] = &nbunny_audio_fft;
	T["melFilterBank"] = &nbunny_audio_mel_filter_bank;
	T["powerToDB"] = &nbunny_audio_power_to_db;
	T["dct"] = &nbunny_audio_dct;

	sol::stack::push(L, T);

	return 1;
}
