class AbstractPrinter
  def initialize(result, options={})
    @result = result
    @options = options
  end
  
  def print
    pp result
  end
end
