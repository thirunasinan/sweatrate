class ImpreportsView < ActiveRecord::Migration[5.0]
 def up
    execute <<-SQL
      CREATE VIEW impreports AS
        SELECT
      a.is_include ,a.date ,CAST(a.time as time),s.name AS "sport",
      a.distance,a.speed ,a.pace ,CAST(a.duration as time) AS "duration",a.effort,
			a.temp_feels_like ,a.weight_before ,a.weight_after,
			a.hydration ,a.sweat_rate ,a.description ,a.notes ,a.user_id  
        FROM
          impactivities a
          INNER JOIN sports s ON a.activity = s.id 
      
    SQL
  end

  def down
    execute "DROP VIEW impreports"
  end
end
