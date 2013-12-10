require 'csv'

task :import_nfl => [:environment] do |t|
  Match.destroy_all
  User.destroy_all
  CSV.foreach(Rails.root.join("lib", "assets", "nfl.csv").to_s) do |row|
    if row[3] == "boxscore"
      team1 = User.where(:name => row[4]).first
      team2 = User.where(:name => row[6]).first
      if team1.nil?
        team1 = User.new(:name => row[4])
        team1.save
      end
      if team2.nil?
        team2 = User.new(:name => row[6])
        team2.save
      end

      #team1_score = row[2].to_i
      #team2_score = row[18].to_i
      m = Match.new
      #m.created_at = DateTime.strptime(row[0], "%m/%d/%Y")
      m.winner = team1 #(team1_score > team2_score ? team1 : team2)
      m.loser = team2 #(team1_score > team2_score ? team2 : team1)
      m.save!
    end
  end
end

task :import_nba => [:environment] do |t|
  Match.destroy_all
  User.destroy_all

  skipped = false
  CSV.foreach(Rails.root.join("lib", "assets", "nba1213.csv").to_s) do |row|
    if !skipped
      skipped = true
    else
      team1 = User.where(:name => row[2]).first
      team2 = User.where(:name => row[4]).first
      if team1.nil?
        team1 = User.new(:name => row[2])
        team1.save
      end
      if team2.nil?
        team2 = User.new(:name => row[4])
        team2.save
      end

      team1_score = row[3].to_f
      team2_score = row[5].to_f
      m = Match.new
      m.created_at = DateTime.strptime(row[0], "%a %b %e %Y")
      m.winner = (team1_score > team2_score ? team1 : team2)
      m.loser = (team1_score > team2_score ? team2 : team1)
      m.score_difference = (m.winner == team1 ? team1_score - team2_score : team2_score - team1_score) ** 0.5
      m.save!
    end
  end
end
