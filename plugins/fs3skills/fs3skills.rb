$:.unshift File.dirname(__FILE__)

module AresMUSH
  module FS3Skills
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("fs3skills", "shortcuts")
    end

    def self.achievements
      Global.read_config('fs3skills', 'achievements')
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "abilities"
        return AbilitiesCmd
      when "specialty"
        if (cmd.switch_is?("add"))
          return AddSpecialtyCmd
        elsif (cmd.switch_is?("remove"))
          return RemoveSpecialtyCmd
        end
      when "learn"
        return LearnAbilityCmd
      when "luck"
        case cmd.switch
        when "award"
          return LuckAwardCmd
        when "spend"
          return LuckSpendCmd
        end
      when "raise", "lower"
        return RaiseAbilityCmd
      when "reset"
        return ResetCmd
      when "roll"
        if (cmd.args =~ / vs /)
          return OpposedRollCmd
        else
          return RollCmd
        end
      when "sheet"
        return SheetCmd
      when "skill"
        case cmd.switch
        when "scan"
          return SkillScanCmd
        end
      when "ability"
        return SetAbilityCmd
      when "xp"
        case cmd.switch
        when "award", "remove"
          return XpAwardCmd    
        when "undo"
          return XpUndoCmd     
        else
          return XpCmd
        end
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return XpCronHandler
      when "CharIdledOutEvent"
        return CharIdledOutEventHandler
      end
      
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "abilities"
        return AbilitiesRequestHandler
      when "addJobRoll"
        return AddJobRollRequestHandler
      when "addSceneRoll"
        return AddSceneRollRequestHandler
      when "fs3Scan"
        return SkillScanRequestHandler
      when "learnAbility"
        return LearnAbilityRequestHandler
      when"spendLuck"
        return SpendLuckRequestHandler
      end
      nil
    end
    
    def self.check_config
      validator = FS3SkillsConfigValidator.new
      validator.validate
    end
  end
end
