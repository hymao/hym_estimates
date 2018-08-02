require 'csv'
require 'byebug'

EST_PRIORITY = {
 'est_sp_JH' => 'John Heraty, 2018',
 'est_sp_JF' => 'Jose Fernandez, 2018', 
 'est_sp_UCD' => 'Universal Chalcidoidea Database, accessed 2018',
 'est_sp_HW' => 'Hymenoptera of the World',
 'est_sp_Wikipedia' => 'Wikipedia, accessed 2018',
 'est_sp_Jones_2009' => 'Jones, 2009',
 'est_sp_JH_2002' => 'JH 2002' 
}

DESC_PRIORITY = { 
  # 'desc_genera_WP' => '',
  'desc_species_WP' => 'WP',
  # 'desc_genera_AG' => '',
  'desc_species_AG' => 'AG', 
  # 'desc_genera_other' => '',
  'desc_species_other' => ''
}

data = CSV.read('data.tsv', headers: true, col_sep: "\t")

def get_values(row, mode = :est)

  a = case mode 
      when :est
        EST_PRIORITY 
      when :desc
        DESC_PRIORITY
      else
        raise
      end 

  v = row.select{|c| a.keys.include?(c.first) && c.last.to_i > 0}
  a.keys.each do |p|
    v.each do |d|
      if d.first == p
        cit = a[p]
        cit = row['other_reference'] if mode == :desc && cit == 'desc_species_other'
        return [d.last, cit] 
      end
    end
  end
  return ['ERROR', nil]

end

data.each do |row|
  puts [ 
    'Hymenoptera',
    row['Family'],
    nil,
    get_values(row),
    get_values(row, :desc),
  ].flatten.join("\t")

end
