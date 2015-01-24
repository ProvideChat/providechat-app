require 'brakeman/checks/base_check'

class Brakeman::CheckSymbolDoS < Brakeman::BaseCheck
  Brakeman::Checks.add_optional self

  UNSAFE_METHODS = [:to_sym, :literal_to_sym, :intern, :symbolize_keys, :symbolize_keys!]

  @description = "Checks for symbol denial of service"

  def run_check
    tracker.find_call(:methods => UNSAFE_METHODS, :nested => true).each do |result|
      check_unsafe_symbol_creation(result)
    end
  end

  def check_unsafe_symbol_creation result
    return if duplicate? result or result[:call].original_line

    add_result result

    call = result[:call]

    if result[:method] == :literal_to_sym
      args = call.select { |e| sexp? e }
    else
      args = [call.target]
    end

    if input = args.map{ |arg| has_immediate_user_input?(arg) }.compact.first
      confidence = CONFIDENCE[:high]
    elsif input = args.map{ |arg| include_user_input?(arg) }.compact.first
      confidence = CONFIDENCE[:med]
    end

    if confidence
      return if safe_parameter? input.match

      message = "Symbol conversion from unsafe string (#{friendly_type_of input})"

      warn :result => result,
        :warning_type => "Denial of Service",
        :warning_code => :unsafe_symbol_creation,
        :message => message,
        :user_input => input.match,
        :confidence => confidence
    end
  end

  def safe_parameter? input
    if call? input
      if node_type? input.target, :params
        input.method == :[] and
        symbol? input.first_arg and
        [:controller, :action].include? input.first_arg.value
      else
        safe_parameter? input.target
      end
    else
      false
    end
  end
end
