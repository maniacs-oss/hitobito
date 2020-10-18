# encoding: utf-8

#  Copyright (c) 2012-2020, CVP Schweiz. This file is part of
#  hitobito_cvp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cvp.

namespace :address do
  desc 'Import Post Addresses'
  task :import => [:environment] do
    Address::Importer.new.run
  end

  desc 'Check Person addresses FILE=01_KontaktDaten.csv'
  task :check, [:file, :environment] do |_t, args|
    fail "Needs KontaktDaten file to work with" unless args[:file]
    pipeline = [
      "csvgrep -c Loeschflag -m ' ' -d '|' #{args[:file]}",
      "csvgrep -c Land -m 'CH'",
      "csvgrep -c Strasse -m ' ' -i",
      "csvgrep -c Postleitzahl -m ' ' -i",
      "csvcut -c Strasse,Hausnummer,HausnummerZusatz,Postleitzahl,Land"
    ].join(' | ')

    file = Rails.root.join('tmp/addresses.csv')
    file.write(`#{pipeline}`) unless file.exist?
    rows = CSV.read(file, headers: true)
    puts "Read #{rows.size} addresses"

    rows.each_with_index do |row, index|
      puts ">> #{index}\n" if (index % 1000).zero?
      puts row unless Address.search(row['Postleitzahl'], row['Strasse']).one?
    end
  end
end
