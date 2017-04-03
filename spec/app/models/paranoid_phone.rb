class ParanoidPhone
  include Mongoid::Document
  include Mongoid::Paranoia

  attr_accessor :after_destroy_called, :before_destroy_called

  field :number, type: String

  embedded_in :person

  before_destroy :before_destroy_stub, :halt_me
  after_destroy :after_destroy_stub

  def before_destroy_stub
    self.before_destroy_called = true
  end

  def after_destroy_stub
    self.after_destroy_called = true
  end

  def halt_me
    should_halt = (person.age == 42)

    if ActiveSupport.version >= Gem::Version.new("5.0.0")
      throw :abort if should_halt
    else
      should_halt ? false : true
    end
  end
end
