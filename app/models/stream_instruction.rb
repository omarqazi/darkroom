class StreamInstruction
  attr_reader :instruction_string
  attr_accessor :function, :args
  def initialize(is)
    self.instruction_string = is
    parse_query_string
    return self
  end
  
  def instruction_string=(newval)
    @instruction_string = newval
    parse_query_string
    return self.instruction_string
  end
  
  def to_json
    {instruction_string: instruction_string,function: function, args: args}.to_json
  end
  
  def generate_string
    "#{function}?#{args.to_query}"
  end
  
  def update_string
    @instruction_string = generate_string
  end
  
  private
  def parse_query_string
    question_comps = instruction_string.split("?")
    self.function = question_comps.shift
    args_string = question_comps.join("?")
    self.args =  Rack::Utils.parse_nested_query(args_string)
  end
end