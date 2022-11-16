class User < ApplicationRecord

    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true

    attr_reader :password



    before_validation :ensure_session_token

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)

        if user && user.is_password?(password)
            return user
        else
            return nil
        end

    end

    def generate_unique_session_token
        token = SecureRandom::urlsafe_base64(16)

        while User.exists?(session_token: token)
            token = SecureRandom::urlsafe_base64(16)
        end

        token
    end

    def reset_session_token
        self.session_token = generate_unique_session_token

        self.save!

        self.session_token

    end

    def ensure_session_token
        self.session_token ||= reset_session_token
    end


    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        bcypt_object = BCrypt::Password.new(self.password_digest)
        bcypt_object.is_password?(password)
    end


end
