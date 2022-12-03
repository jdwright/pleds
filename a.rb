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

db.create_table :derivatives do
  primary_key :id
  # A Stable serial number
  Integer :derivate_serial # 1 DerivativeSerial (fixed serial number for each entry in this table)
  # B Linguistic data
  String :category # 2 category (category of the PIE word stem)
  String :derivative_stem # 3 derivative stem 1 (lemma form of the PIE word stem, usually the ‘strong’ form for stems which alternate)
  String :der_gloss_e # 4 der_glossE (English gloss of PIE word stem)
  String :derivate_stem # 5 derivative stem 2 (‘weak’ alternant of an alternating PIE word stems)
  String :stem3_type # 6 stem3_type (inflectional category or context of use for the alternant in the derivative stem 3 field, if any)
  String :derivative_stem3 # 7 derivative stem 3 (third alternant or inflected form of a PIE word stem, where irregular or semi-regular)
  String :der_gloss_g # 8 der_glossG (mostly incomplete: German gloss of PIE word stem)
  String :accent_class # 9 accent_class (accentual class of PIE word stem)
  String :schema # 10 schema (schematic representation of the alternations of the stem)
  String :derivational_rank  # 11 derivational_rank (integer denoting how ‘basic’ the derivation from the root is. Ris is used in part to establish the order that stems are listed in when displayed underneath their parent root. Re more archaic and simpler derivatives are listed first; complex derivatives or ones which are unlikely to be archaic are listed later.)
  String :notes_deriv  # 12 notes_deriv (extra notes a[ached to the entry) C References/Bibliography
  String :source  # 13 source (citation of data sources) D Link field
  Integer :root_serial # 14 RootSerial (fixed serial number of the root from which the PIE stem (field 3) is derived.)  db[:pie_roots].insert row
end

db.create_table :reflexes do
  primary_key :id
  # A Fixed Serial Number
  Integer :reflex_serial # 1 ReflexSerial (fixed serial number for each record in the table)
  # B Linguistic Information
  # a. language/dialect
  String :language # 2 language (language acronym)
  String :dial # 3 dial (dialect acronym if needed, plus subdialect acronym if necessary)
  # ☞ Sometimes ‘dialect’ amounts to the textual source for certain ancient languages
  # b. cited form
  String :reflex # 4 reflex (cited form of reflex)
  String :phon_form # 5 phon_form (occasionally given: surface or underlying phonological representation)
  # c. glosses
  String :gloss_english # 6 glossEnglish (gloss of reflex or of the citation form if reflex is an inflected form)
  String :other_gloss # 7 other_gloss (uncommon: gloss in a language other than English)
  # d. category information
  String :gencat # 8 gencat (gender and morphosyntactic category of reflex)
  String :inflclass # 9 inflclass (inflectional class — conjugation or declension — of reflex)
  String :minorcat # 10 minorcat (additional morphosyntactic category properties of reflex particularly when it is not the citation
  # form of the lemma in the language in question)
  # e. additional notes
  String :notes  # 11 notes (miscellaneous notes a[ached to the record) C Bibliography/References
  String :source  # 12 source (data sources)
  # D Non-Roman script forms and related data
  String :non_roman  # 13 nonRoman (spelling of reflex in non-Roman script)
  String :non_roman_alt  # 14 nonRoman_alt (alternate non-Roman script spelling of reflex)
  String :cuneiform  # 15 cuneiform (cuneiform spelling of reflex, particularly if logographic)
  String :cuneiform_romanized  # 16 cuneiform_romanized (conventional Romanization of cuneiform)
  String :aramaic  # 17 Aramaic (Aramaic form of Pahlavi logogram)
  # E Link to Derivatives Table
  Integer :derivative_serial  # 18 DerivativeSerial (serial number of PIE stem ‘Derivative’ which reflex is a reflex o_)
end

fn = Dir["../PIE*.tab"].first
File.read(fn).split("\r").each do |x|
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

hist = {}

fn = Dir["../PLEDS*Deriv*.tab"].first
File.read(fn).split("\r").each do |x|
  a = x.split("\t")
  next if a.count < 14
  row = {}
  # A Stable serial number
  row[:derivate_serial] = a[0].to_i # 1 DerivativeSerial (fixed serial number for each entry in this table)
  # B Linguistic data
  row[:category] = a[1] # 2 category (category of the PIE word stem)
  row[:derivative_stem] = a[2] # 3 derivative stem 1 (lemma form of the PIE word stem, usually the ‘strong’ form for stems which alternate)
  row[:der_gloss_e] = a[3] # 4 der_glossE (English gloss of PIE word stem)
  row[:derivate_stem] = a[4] # 5 derivative stem 2 (‘weak’ alternant of an alternating PIE word stems)
  row[:stem3_type] = a[5] # 6 stem3_type (inflectional category or context of use for the alternant in the derivative stem 3 field, if any)
  row[:derivative_stem3] = a[6] # 7 derivative stem 3 (third alternant or inflected form of a PIE word stem, where irregular or semi-regular)
  row[:der_gloss_g] = a[7] # 8 der_glossG (mostly incomplete: German gloss of PIE word stem)
  row[:accent_class] = a[8] # 9 accent_class (accentual class of PIE word stem)
  row[:schema] = a[9] # 10 schema (schematic representation of the alternations of the stem)
  row[:derivational_rank] = a[10] # 11 derivational_rank (integer denoting how ‘basic’ the derivation from the root is. Ris is used in part to establish the order that stems are listed in when displayed underneath their parent root. Re more archaic and simpler derivatives are listed first; complex derivatives or ones which are unlikely to be archaic are listed later.)
  row[:notes_deriv] = a[11] # 12 notes_deriv (extra notes a[ached to the entry) C References/Bibliography
  row[:source] = a[12] # 13 source (citation of data sources) D Link field
  row[:root_serial] = a[13].to_i # 14 RootSerial (fixed serial number of the root from which the PIE stem (field 3) is derived.)  db[:pie_roots].insert row
  db[:derivatives].insert row
end

fn = Dir["../PLEDS*Refl*.tab"].first
File.read(fn).split("\r").each do |x|
  a = x.split("\t")
  # hist[a.count] ||= 0
  # hist[a.count] += 1
  next if a.count < 18
  row = {}
  # A Fixed Serial Number
  row[:reflex_serial] = a[0].to_i # 1 ReflexSerial (fixed serial number for each record in the table)
  # B Linguistic Information
  # a. language/dialect
  row[:language] = a[1] # 2 language (language acronym)
  row[:dial] = a[2] # 3 dial (dialect acronym if needed, plus subdialect acronym if necessary)
  # ☞ Sometimes ‘dialect’ amounts to the textual source for certain ancient languages
  # b. cited form
  row[:reflex] = a[3] # 4 reflex (cited form of reflex)
  row[:phon_form] = a[4] # 5 phon_form (occasionally given: surface or underlying phonological representation)
  # c. glosses
  row[:gloss_english] = a[5] # 6 glossEnglish (gloss of reflex or of the citation form if reflex is an inflected form)
  row[:other_gloss] = a[6] # 7 other_gloss (uncommon: gloss in a language other than English)
  # d. category information
  row[:gencat] = a[7] # 8 gencat (gender and morphosyntactic category of reflex)
  row[:inflclass] = a[8] # 9 inflclass (inflectional class — conjugation or declension — of reflex)
  row[:minorcat] = a[9] # 10 minorcat (additional morphosyntactic category properties of reflex particularly when it is not the citation
  # form of the lemma in the language in question)
  # e. additional notes
  row[:notes] = a[10] # 11 notes (miscellaneous notes a[ached to the record) C Bibliography/References
  row[:source] = a[11] # 12 source (data sources)
  # D Non-Roman script forms and related data
  row[:non_roman] = a[12] # 13 nonRoman (spelling of reflex in non-Roman script)
  row[:non_roman_alt] = a[13] # 14 nonRoman_alt (alternate non-Roman script spelling of reflex)
  row[:cuneiform] = a[14] # 15 cuneiform (cuneiform spelling of reflex, particularly if logographic)
  row[:cuneiform_romanized] = a[15] # 16 cuneiform_romanized (conventional Romanization of cuneiform)
  row[:aramaic] = a[16] # 17 Aramaic (Aramaic form of Pahlavi logogram)
  # E Link to Derivatives Table
  row[:derivative_serial] = a[17].to_i # 18 DerivativeSerial (serial number of PIE stem ‘Derivative’ which reflex is a reflex o_)
  db[:reflexes].insert row
end

