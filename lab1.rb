require 'json'
require 'yaml'

contacts = {}

def add_contact(contacts, name, numbers)
  if contacts.key?(name)
    raise "Contact is already exist"
  end
  contacts[name] ||= []
  contacts[name].concat(numbers).uniq!
  puts "Added contact: #{name} => #{contacts[name].join(', ')}"
end

def edit_contact(contacts, name, new_numbers)
  if contacts.key?(name)
    contacts[name] = new_numbers
    puts "Updated contact: #{name} => #{contacts[name].join(', ')}"
  else
    puts "Contact not found: #{name}"
  end
end

def delete_contact(contacts, name)
  if contacts.delete(name)
    puts "Deleted contact: #{name}"
  else
    puts "Contact not found: #{name}"
  end
end

def search_contact(contacts, query)
  results = contacts.select { |name, _| name.downcase.include?(query.downcase) }
  puts "Search results for '#{query}':"
  if results.empty?
    puts "No contacts found."
  else
    results.each { |name, numbers| puts "#{name}: #{numbers.join(', ')}" }
  end
end

def save_contacts(contacts, format, filename)
  case format
  when 'json'
    File.write(filename, JSON.pretty_generate(contacts))
    puts "Contacts saved to #{filename} (JSON)"
  when 'yaml'
    File.write(filename, contacts.to_yaml)
    puts "Contacts saved to #{filename} (YAML)"
  else
    puts "Unknown format: #{format}"
  end
end

def load_contacts(format, filename)
  case format
  when 'json'
    JSON.parse(File.read(filename))
  when 'yaml'
    YAML.load_file(filename)
  else
    puts "Unknown format: #{format}"
    {}
  end
rescue => e
  puts "Error loading file: #{e.message}"
  {}
end


add_contact(contacts, "Anton", ["0671112233"])
add_contact(contacts, "Anton", ["0504445566", "0937778899"])
add_contact(contacts, "Vladik", ["0993331122"])
edit_contact(contacts, "Anton", ["0670000000"])
delete_contact(contacts, "Vladik")
search_contact(contacts, "ant")

save_contacts(contacts, "json", "contacts_demo.json")
save_contacts(contacts, "yaml", "contacts_demo.yaml")

puts "\nLoaded contacts from JSON:"
loaded_json = load_contacts("json", "contacts_demo.json")
loaded_json.each { |name, numbers| puts "#{name}: #{numbers.join(', ')}" }

puts "\nLoaded contacts from YAML:"
loaded_yaml = load_contacts("yaml", "contacts_demo.yaml")
loaded_yaml.each { |name, numbers| puts "#{name}: #{numbers.join(', ')}" }
