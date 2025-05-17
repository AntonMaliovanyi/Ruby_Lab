u = User.create!(name: "Me1", email: "me1@example.com")
c = u.contacts.create!(name: "Not me1")
c.phone_numbers.create!(number: "+380501234566")


puts "Creating user..."
user = User.new(name: "", email: "invalid_email")
unless user.save
  puts "User not saved: #{user.errors.full_messages.join(', ')}"
end

puts "Creating contact..."
contact = Contact.new(name: "", user: user)
unless contact.save
  puts "Contact not saved: #{contact.errors.full_messages.join(', ')}"
end

puts "Creating phone number..."
pn = PhoneNumber.new(number: "123", contact: contact)
unless pn.save
  puts "Phone number not saved: #{pn.errors.full_messages.join(', ')}"
end
