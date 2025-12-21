local BuildServiceServer = require(game:GetService("ServerScriptService").Services.BuildService.BuildServiceServer)

return function()
	describe("BuildService.attemptBuild", function()
		it("applies per-player cooldown (not shared between players)", function()
			-- SETUP PLAYERS (USE USERID WHEN POSSIBLE TO SIMULATE REAL PLAYERS)
			local playerA: any = game.Players:GetPlayers()[1]
			if not playerA then
				playerA = { Name = "TestPlayerA", Character = nil, UserId = 111 }
			end

			local playerB: any = game.Players:GetPlayers()[2]
			if not playerB then
				playerB = { Name = "TestPlayerB", Character = nil, UserId = 222 }
			end

			expect(BuildServiceServer:isInCooldown(playerA)).to.equal(false)
			expect(BuildServiceServer:isInCooldown(playerB)).to.equal(false)

			local buildA1 = BuildServiceServer:attemptBuild(playerA, CFrame.new())
			expect(buildA1).to.equal(true)

			-- A SHOULD NOW BE IN COOLDOWN
			expect(BuildServiceServer:isInCooldown(playerA)).to.equal(true)

			-- BUILD FOR B SHOULD NOT BE AFFECTED BY A'S COOLDOWN
			local buildB1 = BuildServiceServer:attemptBuild(playerB, CFrame.new())
			expect(buildB1).to.equal(true)
		end)

		it("blocks concurrent requests from the same player", function()
			local player: any = game.Players:GetPlayers()[1]
			if not player then
				player = { Name = "SpamPlayer", Character = nil, UserId = 333 }
			end

			local build1 = BuildServiceServer:attemptBuild(player, CFrame.new())
			expect(build1).to.equal(true)

			-- IMMEDIATELY TRY TO START SECOND BUILD
			local build2 = BuildServiceServer:attemptBuild(player, CFrame.new())
			-- SECOND BUILD SHOULD BE REJECTED DUE TO COOLDOWN FROM FIRST
			expect(build2).to.equal(false)
			expect(BuildServiceServer:isInCooldown(player)).to.equal(true)
		end)

		it("allows building if the cooldown has passed", function()
			local player: any = game.Players:GetPlayers()[1]
			if not player then
				player = { Name = "CooldownPlayer", Character = nil, UserId = 444 }
			end

			local build1 = BuildServiceServer:attemptBuild(player, CFrame.new())
			expect(build1).to.equal(true)

			-- WAIT FOR COOLDOWN TO PASS
			task.wait(BuildServiceServer:getBuildCooldown() + 0.1)

			local build2 = BuildServiceServer:attemptBuild(player, CFrame.new())
			expect(build2).to.equal(true)
		end)
	end)
end
