require "csv"

topics = {}
subjects = {}
code_types = {}

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
      code_type = CodeType.where(key: attrs[:text]).first
      code_type = CodeType.create(key: attrs[:text], name: attrs[:name]) unless code_type
      code_types[attrs[:text]] = code_type
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

      if !code_types[topic_code]
        code_type = CodeType.where(key: topic_code).first
        code_type = CodeType.create(key: topic_code, name: "No Name") unless code_type
        code_types[topic_code] = code_type
      end

      attrs[:code_type] = code_types[topic_code]

      code = Code.where(name: attrs[:name]).first

      if code
        code.update_attributes(attrs)
      else
        code = Code.create(attrs)
      end

      puts code.attributes
      puts code.errors.full_messages
    end
end

