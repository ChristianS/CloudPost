require "rubygems"
require "rake"

require "choctop"

ChocTop.new do |s|
  # Remote upload target (set host if not same as Info.plist['SUFeedURL'])
  s.host     = 'ftp.cloudpostapp.com'
  s.base_url = 'http://cloudpostapp.com/download'
  s.remote_dir = '/cloudpost/download'

  # Custom DMG
  s.background_file = "Images/dmg_background.jpg"
  s.app_icon_position = [100, 90]
  s.applications_icon_position =  [400, 90]
  # s.volume_icon = "dmg.icns"
  # s.applications_icon = "appicon.icns" # or "appicon.png"
end
