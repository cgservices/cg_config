# CG Config
Gem simplify configs in CG Projects.

## Installation
### In Gemfile
gem 'cg_config', :git => "git@github.com:cgservices/digital_codes.git"

## Usage
The gem looks in config/cg for all yml files and loads them into CgConfig::[FILENAME]_CONFIG as a hash with symbols as keys

## Yml files
If the yml file contains the Rails environment as the first key then the config is loaded by environment, otherwise the config is loaded as a whole.

## Custom folder
Cg_config looks in config/cg for the yml files, if you want to use a different folder you can set

    CgConfig::CG_CONFIG_FOLDER

to the folder you would like to load the yml files from.


### Example
    development:
      url: www.myurl.com
      username: myname
      password: mysecretpassword
    production
      url: www.myproductionurl.com
      username: myothername
      password: mysupersecretpassword
