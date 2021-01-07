class UpdateFunctionCreditCardByMonthToUseCreateDate < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE OR REPLACE FUNCTION credit_card_by_month(
        _card_id INT,
        _month INT,
        _year INT
      )
      RETURNS TABLE (
        "limit" NUMERIC,
        super_limit NUMERIC,
        due_date DATE,
        closing_date DATE,
        opening_date DATE
      ) AS $$
      DECLARE
        _due_date DATE;
        _closing_date DATE;
        _opening_date DATE;
        _credit_card RECORD;
      BEGIN
        SELECT credits.limit,
               credits.super_limit,
               credits.due_day,
               credits.closing_day
          INTO _credit_card
          FROM credits
         WHERE credits.id = _card_id;

        SELECT create_date(_year, _month, _credit_card.due_day) INTO _due_date;

        IF _credit_card.closing_day <= _credit_card.due_day THEN
          SELECT create_date(_year, _month, _credit_card.closing_day) INTO _closing_date;
        ELSE
          SELECT date_trunc('day', create_date(_year, _month, _credit_card.closing_day) - interval '1 month')
            INTO _closing_date;
        END IF;

        SELECT date_trunc('day', _closing_date + interval '1 day' - interval '1 month')
          INTO _opening_date;

        RETURN QUERY (
          SELECT _credit_card.limit AS limit,
                 _credit_card.super_limit AS super_limit,
                 _due_date AS due_date,
                 _closing_date AS closing_date,
                 _opening_date AS opening_date
        );
      END; $$
      LANGUAGE 'plpgsql';
    SQL
  end
end
