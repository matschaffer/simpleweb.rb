$LOAD_PATH << File.dirname(__FILE__) + "/lib"
require 'boot'

require './post'

use SimpleWeb::Rest
use SimpleWeb::Erb
run SimpleWeb.app
