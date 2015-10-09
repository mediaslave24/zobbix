# Ruby Zabbix API Wrapper

## Installation
```
gem install zobbix
```

## Usage
```ruby
require 'zobbix'

zbx = Zobbix.connect(uri:      'http://localhost/zabbix',
                     user:     'Admin',
                     password: 'zabbix')

zbx.request('trigger.get')
zbx.request('trigger.create')
```
