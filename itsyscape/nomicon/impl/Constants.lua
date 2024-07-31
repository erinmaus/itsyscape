local Constants = {
    TYPE_VOID    = "void",
    TYPE_STRING  = "string",
    TYPE_NUMBER  = "number",
    TYPE_BOOLEAN = "boolean",
    TYPE_DIVERT  = "divert",
    TYPE_POINTER = "pointer",
    TYPE_LIST    = "list",

    COMMAND_PUSH_VOID                      = "void",
    COMMAND_BEGIN_LOGICAL_EVALUATION       = "ev",
    COMMAND_END_LOGICAL_EVALUATION         = "/ev",
    COMMAND_OUT                            = "out",
    COMMAND_POP                            = "pop",
    COMMAND_RETURN_TUNNEL                  = "->->",
    COMMAND_RETURN_FUNCTION                = "~ret",
    COMMAND_DUPLICATE                      = "du",
    COMMAND_BEGIN_STRING_EVALUATION        = "str",
    COMMAND_END_STRING_EVALUATION          = "/str",
    COMMAND_NO_OPERATION                   = "nop",
    COMMAND_PUSH_CHOICE_COUNT              = "choiceCnt",
    COMMAND_PUSH_TURN_COUNT                = "turn",
    COMMAND_POP_COUNT_DIVERT_TURNS         = "turns",
    COMMAND_PUSH_VISITS                    = "visit",
    COMMAND_PUSH_SHUFFLE_INDEX             = "seq",
    COMMAND_DONE                           = "done",
    COMMAND_END                            = "end",
    COMMAND_BEGIN_TAG                      = "#",
    COMMAND_END_TAG                        = "/#",

    NATIVE_FUNCTION_ADD                    = "+",
    NATIVE_FUNCTION_SUBTRACT               = "-",
    NATIVE_FUNCTION_DIVIDE                 = "/",
    NATIVE_FUNCTION_MULTIPLY               = "*",
    NATIVE_FUNCTION_MODULO                 = "%",
    NATIVE_FUNCTION_UNARY_NEGATE           = "_",
    NATIVE_FUNCTION_EQUAL                  = "==",
    NATIVE_FUNCTION_LESS                   = "<",
    NATIVE_FUNCTION_GREATER                = ">",
    NATIVE_FUNCTION_LESS_THAN_OR_EQUAL     = "<=",
    NATIVE_FUNCTION_GREATER_THAN_OR_EQUAL  = ">=",
    NATIVE_FUNCTION_NOT_EQUAL              = "!=",
    NATIVE_FUNCTION_UNARY_NOT              = "!",
    NATIVE_FUNCTION_LOGICAL_AND            = "&&",
    NATIVE_FUNCTION_LOGICAL_OR             = "||",
    NATIVE_FUNCTION_MIN                    = "MIN",
    NATIVE_FUNCTION_MAX                    = "MAX",
    NATIVE_FUNCTION_POW                    = "POW",
    NATIVE_FUNCTION_FLOOR                  = "FLOOR",
    NATIVE_FUNCTION_CEILING                = "CEILING",
    NATIVE_FUNCTION_INT                    = "INT",
    NATIVE_FUNCTION_FLOAT                  = "FLOAT",
    NATIVE_FUNCTION_INCLUDE                = "?",
    NATIVE_FUNCTION_DOES_NOT_INCLUDE       = "!?",
    NATIVE_FUNCTION_INTERSECT              = "^",
    NATIVE_FUNCTION_LIST_MIN               = "LIST_MIN",
    NATIVE_FUNCTION_LIST_MAX               = "LIST_MAX",
    NATIVE_FUNCTION_LIST_ALL               = "LIST_ALL",
    NATIVE_FUNCTION_LIST_COUNT             = "LIST_COUNT",
    NATIVE_FUNCTION_LIST_VALUE             = "LIST_VALUE",
    NATIVE_FUNCTION_LIST_INVERT            = "LIST_INVERT",

    DIVERT_TO_PATH                         = "->",
    DIVERT_TO_FUNCTION                     = "f()",
    DIVERT_TO_TUNNEL                       = "->t->",
    DIVERT_TO_EXTERNAL_FUNCTION            = "x()",

    ASSIGN_VARIABLE                        = "VAR=",
    ASSIGN_TEMPORARY                       = "temp=",

    FIELD_VARIABLE_REASSIGNMENT            = "re",
    FIELD_DIVERT_EXTERNAL_FUNCTION_ARGS    = "exArgs",
    FIELD_DIVERT_VARIABLE                  = "var",
    FIELD_DIVERT_TARGET                    = "^->",
    FIELD_VARIABLE_POINTER                 = "^var",
    FIELD_CONTEXT_INDEX                    = "ci",
    FIELD_PUSH_VARIABLE_NAME               = "VAR?",
    FIELD_READ_COUNT                       = "CNT?",
    FIELD_CHOICE_POINT_PATH                = "*",
    FIELD_FLAG                             = "flg",

    FLAG_CHOICE_POINT_HAS_CONDITION        = 1,
    FLAG_CHOICE_POINT_HAS_START_CONTENT    = 2,
    FLAG_CHOICE_POINT_HAS_CHOICE_CONTENT   = 4,
    FLAG_CHOICE_POINT_IS_INVISIBLE_DEFAULT = 8,
    FLAG_CHOICE_POINT_ONLY_ONCE            = 16,

    PATH_RELATIVE                          = ".",
    PATH_PARENT                            = "^",
    PATH_SEPARATOR                         = "."
}

local function __index(_self, key)
    local result = Constants[key]
    if result == nil then
        error(string.format("constant with name '%s' not found", tostring(key)))
    end

    return result
end

local function __newindex(_self, _key, _value)
    error("Constants are read-only")
end

return setmetatable({}, {
    __index = __index,
    __newindex = __newindex
})
