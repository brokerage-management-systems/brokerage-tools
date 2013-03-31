class Trade

  # security (i.e. attr_accessible) ...........................................

  attr_accessor :account_number, 
    :account_type,
    :blotter_code,
    :branch,
    :buy_sell_code,
    :cancel_code,
    :cusip,
    :entity_id,
    :market_code,
    :raw_commission,
    :raw_concession,
    :raw_price,
    :raw_principal,
    :raw_quantity,
    :security_description_1,
    :security_description_2,
    :security_type,
    :settle_date,
    :solicitation_code,
    :symbol,
    :trade_date,
    :trade_reference_number,
    :trade_definition_trade_id

  # class methods .............................................................

  def self.as_money raw_number
    Money.new(raw_number,'USD')
  end

  def self.bunch_array_of_trades trades
    # bunched_trades = []
    index = 0
    last_element_checked = false
    sentinal = -1
    until last_element_checked
      limit = (index >= trades.size-1) ? -1 : trades.size
      if limit == sentinal
        last_element_checked = true
        next
      end
      if Trade::should_be_bunched?(trades[index], trades[index+1])
        trades[index] = Trade::bunch_two_trades(trades[index], trades[index+1])
        trades.delete_at(index+1)
      else
        index = index + 1
      end
    end
    # return bunched_trades
  end

  # method: bunch trades
  #   Takes 2 Trades
  #   Sums the Commission, Concession, & Quantity, Averages the Price
  #   Returns single Trade
  def self.bunch_two_trades trade_1, trade_2
    trade = Trade.new
    trade.account_number            = String::new trade_1.account_number
    trade.account_type              = String::new trade_1.account_type
    trade.blotter_code              = String::new trade_1.blotter_code
    trade.branch                    = String::new trade_1.branch
    trade.buy_sell_code             = String::new trade_1.buy_sell_code
    trade.cancel_code               = String::new trade_1.cancel_code
    trade.raw_commission            = trade_1.raw_commission + trade_2.raw_commission
    trade.raw_concession            = trade_1.raw_concession + trade_2.raw_concession
    trade.cusip                     = String::new trade_1.cusip
    trade.entity_id                 = String::new trade_1.entity_id
    trade.market_code               = String::new trade_1.market_code
    trade.raw_price                 = ((trade_1.raw_price + trade_2.raw_price) / 2) + ((trade_1.raw_price + trade_2.raw_price) % 2)
    trade.raw_principal             = trade_1.raw_principal + trade_2.raw_principal
    trade.raw_quantity              = trade_1.raw_quantity + trade_2.raw_quantity
    trade.security_description_1    = String::new trade_1.security_description_1.strip
    trade.security_description_2    = String::new trade_1.security_description_2.strip
    trade.security_type             = String::new trade_1.security_type
    trade.settle_date               = String::new trade_1.settle_date
    trade.solicitation_code         = String::new trade_1.solicitation_code
    trade.symbol                    = String::new trade_1.symbol.strip
    trade.trade_date                = String::new trade_1.trade_date
    trade.trade_reference_number    = String::new trade_1.trade_reference_number[0..-3].insert(-1, '--')
    trade.trade_definition_trade_id = String::new trade_1.trade_definition_trade_id
    return trade
  end

  def self.compare_strings string_1, string_2
    string_1 == string_2
  end

  def self.should_be_bunched? trade_1, trade_2
    return false unless compare_strings trade_1.account_number, trade_2.account_number
    return false unless compare_strings trade_1.cusip, trade_2.cusip
    return false unless compare_strings trade_1.entity_id, trade_2.entity_id
    return false unless compare_strings trade_1.symbol, trade_2.symbol
    return false unless compare_strings trade_1.trade_definition_trade_id, trade_2.trade_definition_trade_id
    return true
  end

  # public instance methods ...................................................

  def commission
    Trade::as_money @raw_commission
  end

  def concession
    Trade::as_money @raw_concession
  end

  def full_account_number
    "#{@branch}-#{@account_number}"
  end

  def price
    Trade::as_money @raw_price
  end

  def principal
    Trade::as_money @raw_principal
  end

  def quantity
    @raw_quantity
  end

  def parse_price_field price
    price.to_f.round(2).to_s.sub('.','').to_i
  end

  def parse_quantity_field quantity
    quantity.to_s.insert(-6, ".").to_i
  end

  def raw_commission=(commission)
    @raw_commission = (commission.class == Fixnum) ? commission : commission.to_i
    if @cancel_code == '1'
      @raw_commission = -@raw_commission
    end
  end

  def raw_concession=(concession)
    @raw_concession = (concession.class == Fixnum) ? concession : concession.to_i
    if @cancel_code == '1'
      @raw_concession = -@raw_concession
    end
  end

  def raw_price=(price)
    @raw_price = (price.class == Fixnum) ? price : parse_price_field(price)
    if @cancel_code == '1'
      @raw_price = -@raw_price
    end
  end

  def raw_principal=(principal)
    @raw_principal = (principal.class == Fixnum) ? principal : principal.to_i
    if @cancel_code == '1'
      @raw_principal = -@raw_principal
    end
  end

  def raw_quantity=(quantity)
    @raw_quantity = (quantity.class == Fixnum) ? quantity : parse_quantity_field(quantity)
    if @cancel_code == '1'
      @raw_quantity = -@raw_quantity
    end
  end

  def pretty_print
    puts "{\n\t'entity_id':'#{@entity_id}'\n\t'account_number':'#{full_account_number}'\n\t'trade_reference_number':'#{@trade_reference_number}'\n\t'trade_date':'#{@trade_date}'\n\t'settle_date':'#{@settle_date}'\n\t'account_type':'#{@account_type}'\n\t'market_code':'#{@market_code}'\n\t'blotter_code':'#{@blotter_code}'\n\t'buy_sell_code':'#{@buy_sell_code}'\n\t'cancel_code':'#{@cancel_code}'\n\t'quantity':'#{@quantity}'\n\t'cusip':'#{@cusip}'\n\t'symbol':'#{@symbol}'\n\t'security_description':'#{@security_description_1} #{@security_description_2}'\n\t'price':'#{@price}'\n\t'principal':'#{@principal}'\n\t'commission':'#{@commission}'\n\t'concession':'#{@concession}'\n\t'solicitation_code':'#{@solicitation_code}'\n\t'security_type':'#{@security_type}'\n\t'trade_definition_trade_id':'#{@trade_definition_trade_id}'\n}"
  end

  def to_json
    puts "{'entity_id':'#{@entity_id}','account_number':'#{full_account_number}','trade_reference_number':'#{@trade_reference_number}','trade_date':'#{@trade_date}','settle_date':'#{@settle_date}','account_type':'#{@account_type}','market_code':'#{@market_code}','blotter_code':'#{@blotter_code}','buy_sell_code':'#{@buy_sell_code}','cancel_code':'#{@cancel_code}','quantity':'#{@quantity}','cusip':'#{@cusip}','symbol':'#{@symbol}','security_description':'#{@security_description_1} #{@security_description_2}','price':'#{@price}','principal':'#{@principal}','commission':'#{@commission}','concession':'#{@concession}','solicitation_code':'#{@solicitation_code}','security_type':'#{@security_type}','trade_definition_trade_id':'#{@trade_definition_trade_id}'}"
  end

  def to_s
    pretty_print
  end
end
