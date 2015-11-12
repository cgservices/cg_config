# CG Config
Gem simplify configs in CG Projects.

## Installation
### In Gemfile
gem 'cg_config', :git => "git@github.com:cgservices/digital_codes.git"

## Usage
The gem looks in config/yml for all yml files and loads them into CgConfig::[FILENAME] as a hash with symbols as keys

## Yml files
If the yml file contains the Rails environment as the first key then the config is loaded by environment, otherwise the config is loaded as a whole.


### Example my_config.yml
    development:
      url: www.myurl.com
      username: myname
      password: mysecretpassword
    production:
      url: www.myproductionurl.com
      username: myothername
      password: mysupersecretpassword

#### Example usage
    CgConfig::MY_CONFIG[:url]
    
## Planned for the future
Cg_config looks in config/yml for the yml files
Next step is to make the folder configurable
by setting CgConfig::CG_CONFIG_FOLDER
