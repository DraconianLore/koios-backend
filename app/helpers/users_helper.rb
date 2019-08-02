module UsersHelper
    def RankCheck(user)
        if user.experience >= 1000
            user.experience -= 1000
            user.rank += 1
            user.save!
            true
        else
            false
        end

    end
end
