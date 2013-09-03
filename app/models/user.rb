class User
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = [:super, :admin, :teacher, :student]
  ADMIN_ROLES = [:super, :admin]
  SITE_ROLES = [:super, :admin, :teacher]
  IPAD_ROLES = [:super, :admin, :teacher]
  PASSWORD_MIN_LENGTH = 4
  TOKEN_EXPIRE_TIME = 1.week

  belongs_to :person

  attr_accessor :password, :password_confirmation

  field :email, type: String
  field :token, type: String
  field :ph, as: :password_hash, type: String
  field :ps, as: :password_salt, type: String
  field :role, type: Symbol

  before_save :prepare_password

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validate :check_password

  class << self
    def auth(email, password)
      user = where(email: email).first
      user = nil unless user && user.password_matches?(password)
      user.generate_token unless user.nil?
      user
    end

    def with_token(token)
      user = where(token: token).reject(&:token_expired?).first
    end
  end

  def check_password
    if password and !password.blank?
      errors.add(:base, 'Password cannot be blank.') if password.blank? or password.nil?
      errors.add(:base, 'Password and confirmation must match.') if password != password_confirmation
      errors.add(:base, "Password must be at least #{PASSWORD_MIN_LENGTH} characters long.") if !password.nil? and password.length < PASSWORD_MIN_LENGTH
    end
  end

  def password_matches?(given_password)
    password_hash == encrypt_password(given_password)
  end

  def generate_token
    update_attribute :token, Digest::SHA1.hexdigest(password_salt + Time.now.to_i.to_s + rand.to_s)
  end

  def can_use_site?
    return SITE_ROLES.include? role
  end

  def can_use_admin?
    return ADMIN_ROLES.include? role
  end

  def token_expired?
    Time.now - updated_at > TOKEN_EXPIRE_TIME
  end

private

  def prepare_password
    if password
      self.password_salt = Digest::SHA1.hexdigest(Time.now.to_i.to_s + rand.to_s)
      self.password_hash = encrypt_password(password)
    end
  end

  def encrypt_password(password)
    Digest::SHA1.hexdigest(password + password_salt)
  end

end

