job_functions_data = [
  { name: "General dentist",             slug: "general_dentist",           position: 1 },
  { name: "Dental hygienist",            slug: "dental_hygienist",          position: 2 },
  { name: "Dental assistant",            slug: "dental_assistant",          position: 3 },
  { name: "Prevention assistant",        slug: "prevention_assistant",      position: 4 },
  { name: "Paro-prevention assistant",   slug: "paro_prevention_assistant", position: 5 },
  { name: "Orthodontic assistant",       slug: "orthodontic_assistant",     position: 6 },
  { name: "Front-office / receptionist", slug: "front_office",              position: 7 },
  { name: "Practice manager",            slug: "practice_manager",          position: 8 },
  { name: "Dental technician",           slug: "dental_technician",         position: 9 },
  { name: "Specialist",                  slug: "specialist",                position: 10 }
]

job_functions_data.each do |attrs|
  JobFunction.find_or_create_by!(slug: attrs[:slug]) do |jf|
    jf.name     = attrs[:name]
    jf.position = attrs[:position]
  end
end

skills_data = {
  "general_dentist"           => [ "Endodontics", "Restorative dentistry", "Pediatric dentistry", "Surgery", "Aligners" ],
  "dental_hygienist"          => [ "Periodontology", "Prevention", "Scaling", "Patient education" ],
  "dental_assistant"          => [ "Chairside assistance", "Sterilization", "Orthodontics", "Prevention" ],
  "prevention_assistant"      => [ "Prevention", "Patient education", "Fluoride", "Sealants" ],
  "paro_prevention_assistant" => [ "Periodontology", "Prevention", "Scaling" ],
  "orthodontic_assistant"     => [ "Orthodontics", "Bracket bonding", "Retainers" ],
  "front_office"              => [ "Planning", "Phone handling", "Invoicing", "Patient communication" ],
  "practice_manager"          => [ "Team management", "Scheduling", "HR", "Practice operations" ],
  "dental_technician"         => [ "Prosthetics", "CAD/CAM", "Crown and bridge work" ],
  "specialist"                => [ "Endodontics", "Implantology", "Orthodontics", "Oral surgery", "Periodontology" ]
}

skills_data.each do |slug, skill_names|
  jf = JobFunction.find_by!(slug: slug)
  skill_names.each do |skill_name|
    Skill.find_or_create_by!(name: skill_name, job_function: jf)
  end
end

languages_data = [
  { name: "Dutch",      code: "nl" },
  { name: "English",    code: "en" },
  { name: "German",     code: "de" },
  { name: "French",     code: "fr" },
  { name: "Spanish",    code: "es" },
  { name: "Arabic",     code: "ar" },
  { name: "Turkish",    code: "tr" },
  { name: "Polish",     code: "pl" },
  { name: "Portuguese", code: "pt" },
  { name: "Italian",    code: "it" }
]

languages_data.each do |attrs|
  Language.find_or_create_by!(code: attrs[:code]) { |l| l.name = attrs[:name] }
end

regions_data = [
  "Noord-Holland", "Zuid-Holland", "Utrecht", "Noord-Brabant",
  "Gelderland", "Overijssel", "Groningen", "Friesland",
  "Drenthe", "Flevoland", "Zeeland", "Limburg"
]

regions_data.each do |name|
  Region.find_or_create_by!(name: name)
end

puts "Seeded: #{JobFunction.count} job functions, #{Skill.count} skills, #{Language.count} languages, #{Region.count} regions"
