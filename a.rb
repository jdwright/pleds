#!/usr/bin/env ruby
require 'sequel'

fn = 'pleds.sqlite'
File.unlink fn if File.exists? fn
db = Sequel.sqlite fn
db.create_table :pie_roots do
  primary_key :id
      # A Stable serial number
      Integer :root_serial # 1 RootSerial (fixed serial number for Root)
      # B Linguistic data
      String :root # 2 Root (PIE root lemma)
      String :category # 3 category (main category label)
      String :gloss_english #4 glossEnglish (gloss in English)
      String :gloss_german # 5 gloss German (incomplete; gloss in German)
      String :basic_aspect # 6 basic aspect (partly incomplete; hypothetical Aktionsart of verbal roots)
      String :sanskrit_root # 7 SanskritRoot (linguistically modern version corresponding Sanskrit root, if any)
      String :skt_root_traditional # 8 SktRootTraditional (traditional version of corresponding Sanskrit root, if any)
      String :skt_root_nagari # 9 SktRootNagari (Devanagari rendering of the romanized SktRootTraditional field)
      String :whitney_root_gloss # 10 Whitney root gloss (English gloss as given by Whiteny of corresponding Sanskrit root if any)
      String :cognates # 11 cognates (partly incomplete; English words derived from this root, including learned borrowings)
      String :nodes # 12 Notes (additional information)
      # b mostly incomplete fields, not used in PLEDS on-line
      String :dervied_aspect # 13 derived_aspect (incomplete and probably superfluous since could be calculated; Aktionsart of derived verbal stems)
      String :verb_type # 14 verb_type (largely incomplete; basically stative vs. inchoative semantics of verbal roots)
      String :semantics # 15 semantics (largely incomplete; intended to contain semantic classification categories)
      # C Cladistics
      String :clade3 # 16 clade_3 (cladistic category for the PIE Root. Although this should be dynamically calculated, when I set it up I didn’t know how to do very complex queries, so I had a script calculate the value and insert it as regular text in the field. Ris needs to be fixed eventually.)
      # D. References/Bibliography
      String :pokorny_root # 17 PokornyRoot (root lemma in Pokorny’s dictionary)
      String :pok # 18 Pok (page numbers in Pokorny’s dictionary)
      String :liv # 19 LIV (page numbers where a verbal root lemma occurs in the Lexicon Indogermanischen Verben)
      String :nil # 20 NIL (page numbers where a nominal root lemma appears in NIL)
      String :source # 21 source (data source aside from those given in the fields above)
      # E Some major calculated fields for searching and sorting
      String :root_init # 22 root_init (calculated — used for sorting on the Root field)
      String :root_search # 23 Root_search (calculated — used for searching in the Root field)
      String :category_search # 24 category_search (calculated — used for searching category label information)

end


Dir["../*.tab"].each do |x|
  if x =~ /PIE/
    File.read(x).split("\r").each do |x|
      a = x.split("\t")
      row = {}
      # A Stable serial number
      row[:root_serial] = a[0].to_i # 1 RootSerial (fixed serial number for Root)
      # B Linguistic data
      row[:root] = a[1] # 2 Root (PIE root lemma)
      row[:category] = a[2] # 3 category (main category label)
      row[:gloss_english] = a[3] #4 glossEnglish (gloss in English)
      row[:gloss_german] = a[4] # 5 gloss German (incomplete; gloss in German)
      row[:basic_aspect] = a[5] # 6 basic aspect (partly incomplete; hypothetical Aktionsart of verbal roots)
      row[:sanskrit_root] = a[6] # 7 SanskritRoot (linguistically modern version corresponding Sanskrit root, if any)
      row[:skt_root_traditional] = a[7] # 8 SktRootTraditional (traditional version of corresponding Sanskrit root, if any)
      row[:skt_root_nagari] = a[8] # 9 SktRootNagari (Devanagari rendering of the romanized SktRootTraditional field)
      row[:whitney_root_gloss] = a[9] # 10 Whitney root gloss (English gloss as given by Whiteny of corresponding Sanskrit root if any)
      row[:cognates] = a[10] # 11 cognates (partly incomplete; English words derived from this root, including learned borrowings)
      row[:nodes] = a[11] # 12 Notes (additional information)
      # b mostly incomplete fields, not used in PLEDS on-line
      row[:dervied_aspect] = a[12] # 13 derived_aspect (incomplete and probably superfluous since could be calculated; Aktionsart of derived verbal stems)
      row[:verb_type] = a[13] # 14 verb_type (largely incomplete; basically stative vs. inchoative semantics of verbal roots)
      row[:semantics] = a[14] # 15 semantics (largely incomplete; intended to contain semantic classification categories)
      # C Cladistics
      row[:clade3] = a[15] # 16 clade_3 (cladistic category for the PIE Root. Although this should be dynamically calculated, when I set it up I didn’t know how to do very complex queries, so I had a script calculate the value and insert it as regular text in the field. Ris needs to be fixed eventually.)
      # D. References/Bibliography
      row[:pokorny_root] = a[16] # 17 PokornyRoot (root lemma in Pokorny’s dictionary)
      row[:pok] = a[17] # 18 Pok (page numbers in Pokorny’s dictionary)
      row[:liv] = a[18] # 19 LIV (page numbers where a verbal root lemma occurs in the Lexicon Indogermanischen Verben)
      row[:nil] = a[19] # 20 NIL (page numbers where a nominal root lemma appears in NIL)
      row[:source] = a[20] # 21 source (data source aside from those given in the fields above)
      # E Some major calculated fields for searching and sorting
      row[:root_init] = a[21] # 22 root_init (calculated — used for sorting on the Root field)
      row[:root_search] = a[22] # 23 Root_search (calculated — used for searching in the Root field)
      row[:category_search] = a[23] # 24 category_search (calculated — used for searching category label information)
      db[:pie_roots].insert row
    end
  end
end



