# Uygulama ve Platform İzleme:

Aşağıdaki adımları izleyerek system-monitor kaynak kodunu bir Docker Container içinde dağıtabilirsiniz.

* Depoyu kendi bilgisayarınıza klonlayın, dizine girin ve master dalına geçin.
    
    git clone https://github.com/tyfnacici/system-monitor.git
    
    cd system-monitor/
    
 ![alt text](/images/git_clone.png)
    
* Dockerfile'dan bir docker imajı oluşturmak için aşağıdaki komutu çalıştırın. Bu komut, kaynak kodu derleyip Node.js uygulamasını docker imajı içinde oluşturacaktır.

            docker build -t system-monitor .
    
* Oluşturduğumuz imajdan bir Container başlatmak için aşağıdaki komutu çalıştırın:
        
            docker run -p 6767:6767 --name system-monitor-container -d system-monitor
    
* Artık oluşturduğumuz Node.js uygulamasına bir Container içinde erişebiliriz. UI ve diğer izleme istatistiklerini görmek için aşağıdaki URL'leri tarayıcınızdan ziyaret edin.

**URL'ler:**

            Uygulama Arayüzü: http://<host-ip>:6767



### Uygulama İzleme:

Burada dağıtılan Node.js uygulamasını Appmetrics-dash ile izliyoruz.

 Appmetrics-dash, Node.js uygulamanızın performansını bir gösterge paneli üzerinden görmenizi sağlar. Gösterge paneli, uygulamayı izlemek için Node Application metrics kullanır.

 Bu, [appmetrics](https://github.com/RuntimeTools/appmetrics) kullanılarak elde edilebilir.

Burada kullandıklarımız:

* [appmetrics-dash](https://www.npmjs.com/package/appmetrics-dash): Uygulama izleme gösterge paneli (path: <host>/appmetrics-dash) uygulamanın çeşitli metriklerini gösteren canlı bir gösterge paneli sağlar: bellek, CPU, HTTP istekleri vb.

 ![alt text](/images/AppMetrics.png)


* [appmetrics-prometheus](https://www.npmjs.com/package/appmetrics-prometheus): Prometheus tarzı çıktı veren bir uç nokta (path: <host>/metrics) sağlar.
* [appmetrics-prometheus](https://www.npmjs.com/package/appmetrics-prometheus): Uygulamanın metriklerini prometheus formatında sunan bir uç nokta sağlar (path: <host>/metrics).


    Node Application Metrics Dashboard'un kurulumu ile ilgili detaylara buradan ulaşabilirsiniz: https://www.npmjs.com/package/appmetrics-dash

### Container Sağlık Kontrolü (Health-Check) İzleme:

* Bir Container'ın sağlığını kontrol etmek için Dockerfile'a HEALTHCHECK talimatları ekledik.
    HEALTHCHECK talimatı şu şekilde belirtilebilir:

        HEALTHCHECK <seçenekler> CMD <komut>

        <seçenekler> şunlar olabilir:

            --interval=SÜRE (varsayılan 30s)

            --timeout=SÜRE (varsayılan 30s)
    
* <komut>, container içinde sağlığı kontrol eden komuttur.

   Eğer sağlık kontrolü etkinse, container üç durumda olabilir:

    **Starting (Başlıyor):** Container başlatılırken ilk durum.

    **Healthy (Sağlıklı):** Komut başarılı olursa container sağlıklıdır.

    **Unhealthy (Sağlıksız):** Komut belirtilen süreden uzun sürerse veya başarısız olursa container sağlıksız kabul edilir. Komut başarısız olursa, belirtilen tekrar sayısı kadar yeniden denenir ve yine başarısız olursa container sağlıksız ilan edilir.

Komutun çıkış durumu container'ın sağlık durumunu gösterir. Kabul edilen değerler:

   **0**: Container sağlıklı.

   **1**: Container sağlıksız.

* Container'ın sağlık durumu aşağıdaki gibi görünebilir. Burada STATUS "healthy" (sağlıklı) olarak gösterilmiştir.

![alt text](/images/docker_ps.png)


* Container'ın sağlık durumunun detaylı JSON çıktısını almak için aşağıdaki komutu çalıştırabilirsiniz:
        
            docker inspect --format='{{json .State.Health}}' system-monitor-container

* Docker istatistiklerini JSON formatında almak için aşağıdaki komutu çalıştırabilirsiniz:

            docker stats --no-stream --format "{{ json . }}" system-monitor-container
    
![alt text](/images/docker_stats1.png)

![alt text](/images/docker_stats2.png)

* Yukarıdaki json çıktısını kullanarak container sağlığı hakkında bildirim/uyarı mekanizmaları oluşturabilirsiniz.
