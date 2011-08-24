Sequel.connect('sqlite://db/development.sqlite')

require 'sequel/model'

class Post < Sequel::Model
end
