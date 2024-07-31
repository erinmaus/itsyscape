local function clearTable(t)
    if table.clear then
        table.clear(t)
        return t
    end

    while #t do
        table.remove(t, #t)
    end

    for key in pairs(t) do
        t[key] = nil
    end

    return t
end

return {
    clearTable = clearTable
}
