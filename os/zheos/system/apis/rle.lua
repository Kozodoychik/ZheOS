function compress(data)
    local compressed = ""
    local char = string.sub(data, 1, 1)
    local rep = 0
    local i = 0
    repeat
        i = i + 1
        if string.sub(data, i, i) ~= char then
            if rep > 1 then
                compressed = compressed..string.char(bit.bor(0x80, rep))
            end
            compressed = compressed..char
            char = string.sub(data, i, i)
            rep = 0
        end
        if rep == 0x7f then
            compressed = compressed..string.char(bit.bor(0x80, rep))..char
            char = string.sub(data, i, i)
            rep = 0
        end
        rep = rep + 1
    until i > #data
    return compressed
end
function decompress(data)
    local decompressed = ""
    local i = 0
    repeat
        i = i + 1
        local char = string.sub(data, i, i)
        if bit.band(0x80, string.byte(char)) == 0x80 then
            local rep = bit.band(0x7f, string.byte(char))
            i = i + 1
            decompressed = decompressed..string.rep(string.sub(data, i, i), rep)
        else
            decompressed = decompressed..char
        end
    until i >= #data
    return decompressed
end