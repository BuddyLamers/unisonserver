require "csv"

topics = {}
subjects = {}

CSV.foreach(Rails.root.join('db', 'subject_codes.csv'), {
    headers: :first_row
  }) do |row|
    attrs = {
      subject: row[0],
      name: row[1],
      text: row[2],
    }

    info = attrs[:name].split('.')

    # this is topic
    if info.length < 2
      topics[attrs[:text]] = attrs[:name]
    else
      topic_code = attrs[:name][/[A-Z]+/]

      # because the code names are not standard
      attrs[:year] = 6

      attrs[:topic] = topics[topic_code] if topics[topic_code]

      if !subjects[attrs[:subject]]
        subject = Subject.where(name: attrs[:subject]).first
        subject = Subject.create(name: attrs[:subject]) unless subject
        subjects[attrs[:subject]] = subject
      end

      attrs[:subject] = subjects[attrs[:subject]]

      code = Code.create(attrs)
      puts code.attributes
      puts code.errors.full_messages
    end
end

