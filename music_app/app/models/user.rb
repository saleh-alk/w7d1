class User < ApplicationRecord

    def generate_unique_session_token
        token = SecureRandom.base64

        while Users.exists?(session_token: token)
            token = SecureRandom.base64
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
end
