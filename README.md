# Ruby Zabbix API Wrapper

## Zabbix server requirements
Zabbix Server version should be 2.2 or 2.4

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

method = 'trigger.create'
params = {
  description: 'Name of the trigger',
  expression: 'Linux Template:system.cpu.util[all,idle,avg1].avg(120)}<5'
}

zbx.request(methods, params)
``` 

## Zabbix Server API

[API reference (2.2)](https://www.zabbix.com/documentation/2.2/manual/api/reference)

[API reference (2.4)](https://www.zabbix.com/documentation/2.4/manual/api/reference)
