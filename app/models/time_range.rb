class TimeRange
  include EnumField::DefineEnum

  attr_reader :start_time, :end_time

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end

  def random_time
    random_hour = rand(start_time...end_time)
    random_minute = rand(0...60)
    "%02d:%02d" % [random_hour, random_minute]
  end

  define_enum do
    member :morning,     object: new(8, 12)
    member :afternoon,   object: new(12, 16)
    member :evening,     object: new(16, 20)
    member :night,       object: new(20, 24)
  end
end
