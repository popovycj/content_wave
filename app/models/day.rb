class Day
  include EnumField::DefineEnum

  define_enum id_start_from: -1 do
    member :sunday
    member :monday
    member :tuesday
    member :wednesday
    member :thursday
    member :friday
    member :saturday
  end
end
