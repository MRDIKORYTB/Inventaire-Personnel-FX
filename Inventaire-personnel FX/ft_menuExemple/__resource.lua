-- @Author: samuelds
-- @Date:   2017-06-08T23:28:39+02:00
-- @Project: FiveM Tools
-- @Last modified by:
-- @Last modified time: 2017-06-11T20:11:34+02:00
-- @License: GNU General Public License v3.0

resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependency 'ft_menuBuilder'

-- Scripts
client_scripts {

  "cl_exemple.lua",
  "config.lua",
  "cl_init.lua",

}

server_scripts {

  "sv_init.lua",

}


ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/ci_h.png',
	'html/ci_f.png',
	'html/cursor.png'
}

ui_page 'ui/ui.html'
files {
    'ui/ui.html',
    'ui/animate.css',
    'ui/pdown.ttf',
    'ui/voice_of_the_highlander.ttf'
}
