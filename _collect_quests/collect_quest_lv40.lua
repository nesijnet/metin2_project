----------------------------------------------------
--COLLECT QUEST_lv40
--METIN2 Collecting Quest
----------------------------------------------------
quest collect_quest_lv40  begin
	state start begin
	end
	state run begin
		when login or levelup with pc.level >= 40  begin
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
		send_letter("&Chaegirab'ın Araştırması ")
	end

	when button or info begin
			say_title("Chaegirab'ın Araştırması ")
			say("")
			say("Uriel'in öğrencisi Biyolog Chaegirab yardımına ihtiyacı var.")
			say("")
			say("Acele et ve ona git.")
			say("")
		end  say("")
                end

                when __TARGET__.target.click or 20084.chat."Dinle" begin
                        target.delete("__TARGET__")
                        say_title_mob()
                        say("")
                        say("Oh, merhaba! Ben sadece canavarlar hakkında bilgi toplamıyorum.")
                        say("Ayrıca değişik dillerde kitapda yazıyorum. Artık dayanamıyorum. Gerçekten zorlaşmaya başladı.")
                        say("")
                        say("Bu işler beni artık zorluyor..")
                        say("Aslında kendi işimi kendim yapmam gerek ama yapamıyorum. Benim için bu işi yapabilir misin?")
                        say("Kesinlikle seni ödüllendireceğim.")
                        say("")
                        wait()
                        say_title_mob()
                        say("")
			say("Seungryong Vadisi hakkında daha çok bilgi edinmek istiyorum? Anlıyor musun.")
			say("")
			say("Oradaki eski kitapların lanet büyüleri hakkında bazı şeyleri sakladığını düşünüyorum.")
			say("Bu kitaplar kesinlikle benim kaçırdığım ve öğrenmek istediğim şeyler.")
			say("Kitapları doğru düzgün inceleyebilmem için lütfen bana her seferinde birer tane kitap getir.")
			say("")
                        wait()
                        say_title_mob()
                        say("")
                        say("Ama bana eski ve yıpranmış kitapları getirme.")
                        say("Araştırmam için onları kullanamam.")
                        say("Araştırmam için yaklaşık olarak 15 adet kitaba ihtiyacım olacak.")
                        say("")
                        say("Unutma her seferinde bir tane kitap.")
                        say("")
                        set_state(go_to_disciple)
                        pc.setqf("duration",0) 
                        pc.setqf("collect_count",0)
                        pc.setqf("drink_drug",0) 
                end
        end
        state go_to_disciple begin
                when letter begin
                        send_letter("&Chaegirab'ın Araştırması ")
                end
                when button or info begin
                        say_title("Eski Çağlardan Büyüler:")
                        say("")
                        say("Uriel'in öğrencisi Biyolog Chaegirab Seungryong Vadisindeki eski büyüler hakkında bir araştırma yürütüyor.")
                        say("")
                        say("Her seferinde birer adet olmak üzere Chaegirab'a 15 adet kitap getir.")
                        say("")
                        say_item_vnum(30047)
                        say_reward("Şu ana kadar ".." "..pc.getqf("collect_count").." adet kitap getirdin.")
                        say("")
                end
				
                when 71035.use begin 
                    if get_time() < pc.getqf("duration") then
						syschat("Görev iksirini şu an kullanamazsın.")
                        return
                    end
                    if pc.getqf("drink_drug")==1 then
						syschat("Görev iksirini zaten kullanmışsın.")
						return
                    end
                    if pc.count_item(30047)==0 then
                        syschat("Görev iksirini ork dişi bulduktan sonra kullanabilirsin.")
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
				syschat("Kırmızı Monokl kullanmana gerek yok. Yeni bir nesne verebilirsin.")
				return
			end
			if pc.getqf("monocles_used") > 2 then
				syschat("Zaten bugün 3 adet Kırmızı Monokl kullandın.")
				return
			end
			if pc.getqf("monocles_used") == 0 then
				pc.setqf("redm_duration", get_time()+24*60*60)
			end
			item.remove()
			pc.setqf("duration", get_time()-1)
			local use = pc.getqf("monocles_used")+1
			pc.setqf("monocles_used",use)
			syschat("Kırmızı Monokl kullanıldı. Şimdi bir diğer Lanet Kitabını Chaegirab'a verebilirsin.")
		end

		when 20084.chat."GM: collect_quest_lv40.skip_delay" with pc.count_item(30047) >0 and pc.is_gm() and get_time() <= pc.getqf("duration") begin
			say_title_mob()
			say("Sen GM'sin. Tamam.")
			pc.setqf("duration", get_time()-1)
			return
		end
            when 20084.chat."The Curse Book" with pc.count_item(30047) >0   begin
                        if get_time() > pc.getqf("duration") then
				if  pc.count_item(30047) >0 then
                                say_title_mob()
                                say("")
                                say("Oh!! Bana bir kitap getirmişsin...")
                                say("Bunu kontrol etmem gerek...")
                                say("Lütfen biraz bekle...")
                                say("")
                                pc.remove_item(30047, 1)
				pc.setqf("duration",get_time()+60*60*8) -----------------------------------22�ð�
				wait()				
                                local pass_percent
                                if pc.getqf("drink_drug")==0 then
                                        pass_percent=70
                                else
                                        pass_percent=100
                                end
                                local s= number(1,100)
                                if s<= pass_percent  then
					if pc.getqf("collect_count")< 14 then         
						local index =pc.getqf("collect_count")+1
						pc.setqf("collect_count",index)     
						say_title_mob()
						say("")
						say("Ohh!! Mükemmel! Teşekkürler...")
						say("Daha "..15-pc.getqf("collect_count").. " adet kitap kaldı.")
						say("Bol şanslar!")
                                                say("")
                                                pc.setqf("drink_drug",0)         
                                                return
                                        end
                                        say_title_mob()
                                        say("")
					say("15 Adet kitabı topladın!")
					say("There is only the Esoteric Soul Stone of the")
					say("temple left, it serves as a key to decipher")
					say("the Curse Books.")
					say("")
					say("The Esoteric Soul Stone can be fetched from the")
					say("Dragon Valley. Can you find one for me?")
                                        say("")
                                        say("")
                                        pc.setqf("collect_count",0)
                                        pc.setqf("drink_drug",0)
                                        pc.setqf("duration",0)
                                        set_state(key_item)
                                        return
                                else
                                say_title_mob()
                                say("")
                                say("Hmm....bu iyi değil.")
                                say("Üzgünüm. Bunu kullanamam.")
                                say("Baksana önemli sayfaları yırtılmış..")
                                say("Lütfen daha sonra bir diğerini getir.")
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
                  say("Üzgünüm....")
                  say("Bana verdiğin kitabın analizini henüz bitiremedim.")
                local hoursleft = (pc.getqf("duration")-get_time())*60*60
                if hoursleft > 12 then
                	say("Bir diğer kitabı yarın getirebilir misin?")
                elseif hoursleft < 1 then
                	say("Bir diğer kitabı bir kaç dakika sonra getirebilir misin?")
                else
		  	say("Bir diğer kitabı bir kaç saat sonra getirebilir misin?")
					end
                  say("")
                  return
                end
        end
end
        state key_item begin
                when letter begin
                        send_letter("&Chaegirab'ın Araştırması ")
                        if pc.count_item(30221)>0 then
                                local v = find_npc_by_vnum(20084)
                                if v != 0 then
                                        target.vid("__TARGET__", v, "Biyolog Chaegirab")
                                end
                        end
                end
                when button or info begin
                        if pc.count_item(30221) >0 then
                                say_title("Tapınağın Ruh Taşı:")
                                say("")
                                say("Sonunda Tapınağın Ruh Taşını buldun git ve onu Chaegirab'a ver.")
                                say("")
                                return
                        end
                        say_title("Tapınağın Ruh Taşı:")
                        say("")
			say("Chaegirab'ın araştırması için ona 15 take kitap getirdin.")
			say("Biyolog Chaegirab'a son olarak Tapınağın Ruh Taşı gerekiyor.")
			say("")
			say_item_vnum(30221)
			say("Tapınağın Ruh Taşını bulduğun zaman Chaegirab'a teslim et.")
			say("Ruh Taşını Seungryong Vadisindeki Tapınaktan bulabilirsin...")
			say("")
                end
					when 701.kill or
						 702.kill or
						 703.kill or 
						 704.kill or
						 705.kill or
						 706.kill or
						 707.kill begin
                        local s = number(1, 300)
                        if s == 1 and pc.count_item(30221)==0 then
                                pc.give_item2(30221, 1)
                                send_letter("&Tapınağın Ruh Taşını Buldun!")
                        end
                end
			when __TARGET__.target.click  or 20084.chat."Tapınağın Ruh Taşını Buldum" with pc.count_item(30221) > 0  begin
			target.delete("__TARGET__")
			if pc.count_item(30221) > 0 then 
			say_title_mob()
			say("")
			say("Ohh!!! Çok teşekkürler..")
			say("Sana ödül olarak iç gücünü yükseltebileceğin bir reçete yapacağım.")
			say("Bu özel reçete iç gücünü hangi bitkilerle yükseltebileceğin hakkında")
			say("özel bilgiler içeriyor. Bunu Baek-Go'ya ver. Senin için iksir yapacak.")
			say("Bol Şanslar.")
			say("")
			pc.remove_item(30221,1)
			set_state(__reward)
			else
				say_title_mob()
				say("")
				say("Sende "..item_name(30221).." yok!")
				say("")
				return
			end
                end
        end
        state __reward begin
                when letter begin
                        send_letter("&Chaegirab'ın Ödülü ")
                        local v = find_npc_by_vnum(20018)
                        if v != 0 then
                                target.vid("__TARGET__", v, "Baek-Go")
                        end
                end
                when button or info begin
                        say_title("Chaegirab'ın Ödülü:")
						say("Tapınağın Ruh Taşını bulduğun için ve 15 adet Lanet Kitabı getirdiğin için;")
						say("Chaegirab sana ödül olarak gizli bir reçete verdi.")
						say("Bu reçeteyi Baek-Go'ya götür ve ondan iksir yapmasını iste.")
                        say("")
                end
                when __TARGET__.target.click  or 20018.chat."Gizli Reçete"  begin
						target.delete("__TARGET__")
                        say_title_mob()
                        say("")
                        say("Bir bakalım..")
                        say("Bu reçete ne için?")
                        say("Hmm, Saldırı Hızı +5%...")
                        say("Oh! Şunuda al; Kırmızı Abanoz Sandık.")
                        say("Gerçekten iyisin.")
                        say("")
                        say_reward("Biyolog Chaegirab'ın görevini tamamladığın için +%5 atak hızı kazandın.")
                        say("")
                        say_reward("Bu etki geçici değil, kalıcı.")
						affect.add_collect(apply.ATT_SPEED,5,60*60*24*365*60) --60��		
                        pc.give_item2(50110)
                        clear_letter()
                        set_quest_state("collect_quest_lv50", "run")
                        set_state(__complete)
                end
        end
        state __complete begin
        end
end
