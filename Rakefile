require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
  t.ruby_opts = ['-rtest_helper']
end

task default: :test
