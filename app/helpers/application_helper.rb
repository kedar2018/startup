module ApplicationHelper
def flash_class(type)
    case type.to_s
    when "notice", "success" then "flash--success"
    when "alert", "error"    then "flash--danger"
    else                          "flash--info"
    end
  end
end
