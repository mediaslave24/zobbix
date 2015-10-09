require 'zobbix/credentials'

class Zobbix
  class CredentialsTest < Minitest::Test
    def credentials(hash)
      Credentials.new(hash)
    end

    def it_recognizes(name)
      word = FFaker::Lorem.word
      assert_equal(credentials(name.to_s => word).public_send(name),
                   word)
      assert_equal(credentials(name.to_sym => word).public_send(name),
                   word)
    end

    def test_it_recognizes_all_options
      it_recognizes :host
      it_recognizes :port
      it_recognizes :user
      it_recognizes :password
    end
  end
end
