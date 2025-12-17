local Config = require('config')

-- MY-CUSTOM: Commented out cartoon backdrops - WezTerm defaults to black background
-- To re-enable anime backgrounds, uncomment the lines below:
-- require('utils.backdrops')
--    :set_images()
--    :random()

require('events.left-status').setup()
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })
require('events.tab-title').setup({ hide_active_tab_unseen = false, unseen_icon = 'numbered_box' })
require('events.new-tab-button').setup()
require('events.gui-startup').setup()

return Config:init()
   :append(require('config.my-custom'))  -- MY-CUSTOM: accessibility overrides (load FIRST for priority)
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
