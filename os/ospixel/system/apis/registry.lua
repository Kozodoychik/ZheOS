regpath = 'ospixel/system/.registry'
function createReg()
    fs.makeDir(regpath)
    fs.makeDir(regpath..'/system')
    fs.makeDir(regpath..'/user')
end
function createKey(regname, keyname, keycontent)
    reg = fs.open(regpath..'/'..regname..'/'..keyname, 'w')
    reg.writeLine(keycontent)
    reg.close()
end
function readKey(regname, keyname)
    reg = fs.open(regpath..'/'..regname..'/'..keyname, 'r')
    local content = reg.readLine()
    reg.close()
    return content
end
