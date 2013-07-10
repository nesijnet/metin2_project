----------------------------------------------------
--COLLECT QUEST_lv30
--METIN2 Collecting Quest
----------------------------------------------------
quest collect_quest_lv30  begin
	state start begin
		when login or levelup with pc.level >= 30 begin
			set_state(information)
		end
	end
			
	state information begin
		when letter begin
			local v = find_npc_by_vnum(20084)
			if v != 0 then
				target.vid("__TARGET__", v, "Biyolog Chaegirab")
			end
			q.set_icon("scroll_open_green.tga")
			send_letter("&Chaegirab'ýn Araþtýrmasý ")
		end
					
		when button or info begin
			say_title_mob()
			say("")
			say("Uriel'in öðrencisi Biyolog Chaegirab yardýmýna ihtiyacý var.")
			say("")
			say("Acele et ve ona git.")
			say("")
		end
		
		when __TARGET__.target.click or 20084.chat."Yardýmýna ihtiyacým var." begin
			target.delete("__TARGET__")
			say_title_mob()
			say("")
			say("Oh!!! Lütfen bana yardým et...")
			say("")
			say("Krallýðýmýzdaki canavarlar hakkýnda araþtýrma yapýyorum.")
			say("Ama bunu sadece kendim yapamam! Ben sadece bir bilim adamýyým anlayabiliyor musun?")
			say("... ve bir bilim adamý olarak sorunlarýmý anladýðýný umut ediyorum.")
			say("")
			say("Lütfen bana yardým et. Kesinlikle ödülü vereceðim.")
			say("")
			wait()
			say_title_mob()
			say("")
			say("Seungryong Vadisindeki orklar ile ilgili bir araþtýrma yürütüyorum.")
			say("Orklarýn diþleri bir demir parçasýný ezebilir.")
			say("")
			say("Bu bu araþtýrmayý yapmamýn sebebi.")
			say("")
			say("Teorim ork diþleri ile ilgili. Belki bunun sýrrýný çözebilirsek bir devrim yapabiliriz!")
			say("")
			wait()
			say_title_mob()
			say("")
			say("Bana biraz ork diþi getirebilir misin?")
			say("")
			say("Diþleri bana sadece teker teker getir ki onlarý doðru düzgün inceleyebileyim.")
			say("Bol þanslar!")
			say("")
			set_state(go_to_disciple)
			pc.setqf("duration",0)
			pc.setqf("collect_count",0)
			pc.setqf("drink_drug",0)
		end
	end

	state go_to_disciple begin
		when letter begin
			send_letter("&Chaegirab'ýn Araþtýrmasý ")
		end

		when button or info begin
			say_title("Seungryong Vadisindeki Ork Diþleri:")
			say("")
			say("Biyolog Chaegirab'ýn araþtýrmasýný sürdürebilmesi için Seungryong Vadisindeki ork diþlerine")
			say("ihtiyacý var.")
			say("")
			say("Araþtýrabilmesi için ona diþleri teker teker ver.")
			say("")
			say_item_vnum(30006)
			say_reward("Þu ana kadar "..pc.getqf("collect_count").." adet ork diþi topladýn.")
			say("")
		end
					
        when 71035.use begin 
			if get_time() < pc.getqf("duration") then
				syschat("Görev iksirini þu an kullanamazsýn.")
				return
			end
			if pc.getqf("drink_drug")==1 then
				syschat("Görev iksirini zaten kullanmýþsýn.")
				return
			end
			if pc.count_item(30006)==0 then
				syschat("Görev iksirini ork diþi bulduktan sonra kullanabilirsin.")
				return
			end
			item.remove()
			pc.setqf("drink_drug",1)
		end
		
		when 70030.use begin
			if get_time() > pc.getqf("redm_duration") then
				pc.setqf("monocles_used", 0)
			end
			if get_time() > pc.getqf("duration") then
				syschat("Kýrmýzý Monokl kullanmana gerek yok. Yeni bir nesne verebilirsin.")
				return
			end
			if pc.getqf("monocles_used") > 2 then
				syschat("Zaten bugün 3 adet Kýrmýzý Monokl kullandýn.")
				return
			end
			if pc.getqf("monocles_used") == 0 then
				pc.setqf("redm_duration", get_time()+24*60*60)
			end
			item.remove()
			pc.setqf("duration", get_time()-1)
			local use = pc.getqf("monocles_used")+1
			pc.setqf("monocles_used",use)
			syschat("Kýrmýzý Monokl kullanýldý. Þimdi bir diðer Ork Diþini Chaegirab'a verebilirsin.")
		end
		
		when 20084.chat."GM: Gecikmeyi Geç lv30" with pc.count_item(30006) >0 and pc.is_gm() and get_time() <= pc.getqf("duration") begin
			say_title_mob()
			say("Sen GM'sin. Tamam.")
			pc.setqf("duration", get_time()-1)
			return
		end
		
		when 20084.chat."Ork Diþleri" with pc.count_item(30006) >0 begin
			if get_time() > pc.getqf("duration") then
				if  pc.count_item(30006) >0 then
					say_title_mob()
					say("")
					say("Merhaba! Bana bir Ork Diþi mi getirdin?!")
					say("Ýlk olarak kontrol etmem gerek...")
					say("Bana bir dakika ver.")
					say("")
					pc.remove_item("30006",1)
					pc.setqf("duration",get_time()+6*60*60) 
					wait()
					local pass_percent
					if pc.getqf("drink_drug")==0 then
						pass_percent=70
					else
						pass_percent=100
					end
					local s= number(1,100)
					if s<= pass_percent  then
						if pc.getqf("collect_count")< 9 then
							local index =pc.getqf("collect_count")+1
							pc.setqf("collect_count",index)
							say_title_mob()
							say("")
							say("Oh!!! Ýþte bu...")
							say("Lütfen bana "..10-pc.getqf("collect_count").. " tane daha ork diþi getir.")
							say("Araþtýrma için bana bu diþlerden daha fazlasý gerek.")
							say("Bol þanslar!")
							say("")
							pc.setqf("drink_drug",0)
							return
						end
						say_title_mob()
						say("")
						say("Bütün Ork Diþlerini topladýn!")
						say("")
						say("Þimdi bana araþtýrmamý tamamen bitirebilmem için Jinunggynin Ruh Taþý gerek.")
						say("")
						say("Bu taþý orklardan elde edebilirsin.")
						say("")
						pc.setqf("collect_count",0)
						pc.setqf("drink_drug",0)
						pc.setqf("duration",0)
						set_state(key_item)
						return
					else
						say_title_mob()
						say("")
						say("Hmm... Bu kýrýk gözüküyor.")
						say("Üzgünüm. Bunu kullanamam.")
						say("Lütfen bana bir diðerini getirebilir misin?")
						say("")
						pc.setqf("drink_drug",0)
						return
					end
				else
					say_title_mob()
					say("")
					say("Sende "..item_name(30006).." yok!")
					return
				end
			else
				say_title_mob()
				say("")
				say("Çok üzgünüm....")
				say("Bana verdiðin ork diþinin analizini henüz bitiremedim!")
				local hoursleft = (pc.getqf("duration")-get_time())/60/60
				if hoursleft > 12 then
					say("Lütfen bu diþi bana yarýn getirebilir misin?")
				elseif hoursleft < 1 then
					say("Lütfen bu diþi bana bir kaç dakika sonra getirebilir misin?")
				else
					say("Lütfen bu diþi bana bir kaç saat sonra getirebilir misin?")
				end
				return
			end
		end
	end
			
	state key_item begin
		when letter begin
			send_letter("&Chaegirab'ýn Araþtýrmasý ")
			if pc.count_item(30220)>0 then
				local v = find_npc_by_vnum(20084)
				if v != 0 then
					target.vid("__TARGET__", v, "")
				end
			end
		end
		
		when button or info begin
			if pc.count_item(30220) >0 then
				say_title("Ruh Taþý:")
				say("")
				say_reward("Sonunda Jinunggynin Ruh Taþýný buldun!")
				say_reward("Onu Biyolog'a götür.")
				say_reward("Seni bekliyor.")
				say("")
				return
			end
			say_title("Özel Taþ:")
			say("")
			say("10 Adet ork diþini topladýn..")
			say("Biyolog Chaegirab'ýn araþtýrmasýný tamamen bitirmek için Jinunggynin Ruh Taþýna ihtiyacý var.")
			say("")
			say_item_vnum(30220)
			say("Taþý bulduðunda Biyolog Chaegirab'a götür.")
			say("Bu taþý þu orklardan bulabilirsin: "..mob_name(635)..", "..mob_name(636).." ve "..mob_name(637)..".")
			say("")
		end
					
		when 635.kill or 636.kill or 637.kill  begin
			local s = number(1, 100)
			if s == 1 and pc.count_item(30220)==0 then
				pc.give_item2(30220, 1)
				send_letter("&Jinunggynin Ruh Taþýný buldun!")
			end
		end
					
		when __TARGET__.target.click or 20084.chat."Jinunggynin Ruh Taþýný buldum." with pc.count_item(30220) > 0  begin
			target.delete("__TARGET__")
			if pc.count_item(30220) > 0 then 
				say_title_mob()
				say("")
				say("Ohh!!! Çok teþekkür ederim.")
				say("Ödül olarak seni güçlendireceðim.")
				say("Bu özel reçete çok özel bitkilerden yapýldý. Sana daha fazla güç verecek.")
				say("Bunu Baek-Go'ya götür. Senin için bu reçeteden iksir yapacak.")
				say("Ýyi Eðlenceler.")
				say("Senin yardýmýnla orklar hakkýnda çok þey öðrendim!")
				say("")
				pc.remove_item(30220,1)
				set_state(__reward)
			else
				say_title_mob()
				say("Sende "..item_name(30220).." yok!")
				say("")
				return
			end
		end
	end
			
	state __reward begin
		when letter begin
			send_letter("&Gizli Reçete")
			local v = find_npc_by_vnum(20018)
			if v != 0 then
				target.vid("__TARGET__", v, "Baek-Go")
			end
		end
	
		when button or info begin
			say_title("Biyolog Chaegirab'ýn Ödülü:")
			say("")
			say("Ork Diþi ve Jinunggynin Ruh Taþýna ödül olarak Biyolog Chaegirab sana özel bir reçete verdi.")
			say("Bu reçeteyi sana özel iksiri yapmasý için Baek-Go'ya götür.")
			say("")
		end
		
		when __TARGET__.target.click or 20018.chat."Gizli Reçete"  begin
			target.delete("__TARGET__")
			say_title_mob()
			say("")
			say("Bir bakalým..")
			say("Yani bu reçete Biyolog Chaegirab'ýn sana verdiði reçete mi?")
			say("Hmm, arttýrýlmýþ hareket hýzý. Fena deðil ha?")
			say("Oh! al bakalým, Kýrmýzý Abanoz sandýk.")
			say("")
			say_reward("Biyolog Chaegirab'ýn görevini tamamladýðýn için +10 hareket hýzý kazandýn.")
			say("")
			say_reward("Bu etki geçici deðil, kalýcý.")
			affect.add_collect(apply.MOV_SPEED, 10, 60*60*24*365*60) -- 60 Years
			pc.give_item2(50109)
			clear_letter()
			set_quest_state("collect_quest_lv40", "run")
			set_state(__complete)
		end
	end
	state __complete begin
	end
end