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

response = zbx.request(methods, params)

response.class #=> Zobbix::ApiResponse

version = zbx.request('apiinfo.version')

version.result #=> "2.4.6"
version.success? #=> true

error = zbx.request('unknown.method')
error.error? #=> true
error.result #=> nil
error.error_code #=> -32602
error.error_message #=> "Invalid params."
error.error_data #=> 'Incorrect API "unknown".'
error.raise_exception #=> Zobbix::Error: API returned error. Code: -32602 Message: Invalid params. Data: Incorrect API "unknown".
``` 

## API Exceptions
```ruby
# Enable API exceptions

zbx = Zobbix.connect(uri:      'http://localhost/zabbix',
                     user:     'Admin',
                     password: 'zabbix',
                     raise_exceptions: true)
zbx.request('unknown.method') #=> Zobbix::Error: API returned error. Code: -32602 Message: Invalid params. Data: Incorrect API "unknown".
```

## Zabbix Server API

[API reference (2.2)](https://www.zabbix.com/documentation/2.2/manual/api/reference)

[API reference (2.4)](https://www.zabbix.com/documentation/2.4/manual/api/reference)
