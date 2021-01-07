class CreateFunctionCreateDate < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE OR REPLACE FUNCTION create_date(
        _year INT,
        _month INT,
        _day INT
      )
      RETURNS DATE AS $$
      DECLARE
        _last_day INT;
        _closing_day INT;
      BEGIN
        SELECT EXTRACT(DAY FROM date_trunc('day', make_date(_year, _month, 1) + interval '1 month' - interval '1 day'))
          INTO _last_day;

        SELECT CASE
                 WHEN _last_day < _day THEN _last_day
                 ELSE _day
               END
          INTO _closing_day;

        RETURN make_date(_year, _month, _closing_day);
      END; $$
      LANGUAGE 'plpgsql';
    SQL
  end
end
