# frozen_string_literal: true

require_relative "mc_server/version"
require_relative "mc_server/server_not_started_error"
require_relative "mc_server/server_already_running_error"
require_relative "mc_server/minecraft_server"

module MC_Server
  VALID_COMMANDS = ["/advancement",
                    "/attribute",
                    "/execute",
                    "/bossbar",
                    "/clear",
                    "/clone",
                    "/data",
                    "/datapack",
                    "/debug",
                    "/defaultgamemode",
                    "/difficulty",
                    "/effect",
                    "/me",
                    "/enchant",
                    "/experience",
                    "/xp",
                    "/fill",
                    "/forceload",
                    "/function",
                    "/gamemode",
                    "/gamerule",
                    "/give",
                    "/help",
                    "/item",
                    "/kick",
                    "/kill",
                    "/list",
                    "/locate",
                    "/locatebiome",
                    "/loot",
                    "/msg",
                    "/tell",
                    "/w",
                    "/particle",
                    "/placefeature",
                    "/playsound",
                    "/recipe",
                    "/say",
                    "/schedule",
                    "/scoreboard",
                    "/setblock",
                    "/spawnpoint",
                    "/setworldspawn",
                    "/spectate",
                    "/spreadplayers",
                    "/stopsound",
                    "/summon",
                    "/tag",
                    "/team",
                    "/teammsg",
                    "/tm",
                    "/teleport",
                    "/tp",
                    "/tellraw",
                    "/time",
                    "/title",
                    "/trigger",
                    "/weather",
                    "/worldborder",
                    "/jfr",
                    "/ban-ip",
                    "/banlist",
                    "/ban",
                    "/deop",
                    "/op",
                    "/pardon",
                    "/pardon-ip",
                    "/perf",
                    "/save-all",
                    "/setidletimeout",
                    "/whitelist"].freeze
end
