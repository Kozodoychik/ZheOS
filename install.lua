term.setBackgroundColor(colors.blue)
term.clear()
term.setCursorPos(1,1)
print('OSPixel v.1.0.0 Setup')
term.write('Install OSPixel? (y/n) ')
local ans = read()
if ans == 'y' then
    if fs.isDir('ospixel') then
        term.write('OSPixel is already installed. Continue?  (y/n)')
        ans2 = read()
        if ans2 == 'y' then
           fs.delete('/ospixel')
        else
           exit()
        end
    end
    term.write('Username: ')
    local user = read()
    print('Collecting installer data...')
    shell.run('pastebin','get','nJhjXFCF','.temp/setup.lua')
    shell.run('.temp/setup', user)
else
    shell.exit()
end
