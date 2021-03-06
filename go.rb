
#
# Raw data originate from https://docs.google.com/spreadsheets/d/1viJlJpqu23a0lQMaCaf3_immHqj6J8DtaZZWA4V6ZxQ/edit#gid=1460381540
#

require 'csv'
require 'byebug'

EST_PRIORITY = %w{ 
  est_sp_JH
  est_sp_JH_2002
  est_sp_UCD
  est_sp_JFT
  est_sp_Jones_2009
  est_sp_HW
  est_sp_Wikipedia
} 

DESC_PRIORITY = %w{
  desc_species_other
  desc_species_AG
  desc_species_HW
  desc_species_Wikipedia
}

EST_SOURCES = {
  'est_sp_JH' => 'John Heraty, 2018',
  'est_sp_JFT' => 'José L. Fernández-Triana, 2018', 
  'est_sp_UCD' => 'Universal Chalcidoidea Database, accessed 2018',
  'est_sp_HW' => 'Hymenoptera of the World',
  'est_sp_Wikipedia' => 'Wikipedia, accessed 2018',
  'est_sp_Jones_2009' => 'Jones, Owen R., et al. "Using taxonomic revision data to estimate the geographic and taxonomic distribution of undescribed species richness in the Braconidae (Hymenoptera: Ichneumonoidea)." Insect Conservation and Diversity 2.3 (2009): 204-212.',
  'est_sp_JH_2002' => 'Heraty, John Michael. Revision of the genera of Eucharitidae (Hymenoptera: Chalcidoidea) of the world. American Entomological Institute, 2002.' 
}

DESC_SOURCES = { 
  'desc_species_HW' => 'Hymenoptera of the World',
  'desc_species_Wikipedia' => 'Wikipedia/Wikispecies',
  'desc_species_AG' => 'Aguiar, Alexandre P., et al. "Order hymenoptera." Zootaxa 3703.1 (2013): 51-62.', 
  'desc_species_other' => ''
  # 'desc_genera_WP' => '',
  # 'desc_genera_AG' => '',
  # 'desc_genera_other' => '',
}

data = CSV.read('data.tsv', headers: true, col_sep: "\t")

# puts "\n"
# puts "desc:" + data.headers.select{|h| h =~ /desc_.*/}.join("\n")
# puts "\n"
# puts "est:" + data.headers.select{|h| h =~ /est_.*/}.join("\n")

def get_values(row, mode = :est)

  a = case mode 
      when :est
        EST_PRIORITY 
      when :desc
        DESC_PRIORITY
      else
        raise
      end 

  b = case mode 
      when :est
        EST_SOURCES
      when :desc
        DESC_SOURCES
      else
        raise
      end 

  v = row.select{|c| a.include?(c.first) && c.last.to_i > 0}
  a.each do |p|
    v.each do |d|
      if d.first == p
        cit = b[p]
#        byebug if mode == :desc
        cit = row['other_reference'] if mode == :desc && p == 'desc_species_other'
        return [d.last, cit] 
      end
    end
  end
  return ['ERROR', nil]

end

# Generate the TSV

data.each do |row|
  puts [ 
    'Hymenoptera',
    row['Family'],
    nil,
    get_values(row, :desc),
    get_values(row),
  ].flatten.join("\t")

end
