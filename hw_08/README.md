#### 3DSnap

1. Поднимаем кластер k8s в GKE
2. Создаем ClusterRoleBinding
```
kubectl create clusterrolebinding cluster-admin-binding \
--clusterrole cluster-admin \
--user $(gcloud config get-value account) 
```
 
 ```
clusterrolebinding.rbac.authorization.k8s.io/cluster-admin-binding created
 ```

3. Устанливаем portworx

* Необходимо добавить права для нод K8s compute_rw storage_ro

* Создалим  сервисную роль
```
kubectl create clusterrolebinding av-cassandra-k8s-cluster-cluster-admin-binding \
    --clusterrole=cluster-admin --user=`gcloud info --format='value(config.account)'`
```

*  на сайте деплоймент манифест и применим его

```
kubectl aplay -f 'https://install.portworx.com/2.6?mc=false&kbver=1.16.15-gke.4901&oem=esse&user=563a274f-42fb-11eb-a2c5-c24e499c7467&b=true&s=%22type%3Dpd-standard%2Csize%3D30%22&kd=type%3Dpd-standard%2Csize%3D150&c=px-cluster-e06f8e96-0229-425b-a296-17fb1c18e97f&gke=true&stork=true&lh=true&st=k8s'
```

```
kubectl get pods -n=kube-system -l name=portworx                                   
NAME             READY   STATUS    RESTARTS   AGE
portworx-7saw2   1/1     Running   0          6m40s
portworx-cdmtq   1/1     Running   0          6m40s
portworx-gm4hp   1/1     Running   0          6m40s
```

kubectl delete -f 'https://install.portworx.com/2.6?mc=false&kbver=1.16.15-gke.4901&oem=esse&user=563a274f-42fb-11eb-a2c5-c24e499c7467&b=true&s=%22type%3Dpd-standard%2Csize%3D30%22&kd=type%3Dpd-standard%2Csize%3D150&c=px-cluster-e06f8e96-0229-425b-a296-17fb1c18e97f&gke=true&stork=true&lh=true&st=k8s'

**Не работает** -  снапшоты не делаются.

Если делать по [инструкции](https://portworx.com/run-ha-cassandra-google-kubernetes-engine-gke/)  - то, при создании pvc  - получаем ошибку о просроченной лицензии.

```
Events:
  Type     Reason              Age                 From                         Message
  ----     ------              ----                ----                         -------
  Warning  ProvisioningFailed  20s (x7 over 117s)  persistentvolume-controller  Failed to provision volume with StorageClass "px-storageclass": rpc error: code = Internal desc = Failed to create volume: Volume (Name: pvc-f6943e4c-87dd-4733-a870-003386b3e461) create failed: License has expired
```

Судя по описанию на форуме поддержки, чинить это они не собираются, поскольку фича нормально работает в Enterprise  версии.

Времени убил много - пэтому изыскания прекращу - видимо надо искать другие средства бекапа или тратить больше врмени на изучение Portworx.

---

#### Driver Performance

1. Выбираем 2 драйвера 
   * Datastax
   * Kundera
  
2. Тестируем:
   * Убирваем в классе Main вызовы остальных драйверов.
   * Производим тестовые прогоны с число CRUD операция 1000 5000 10000
   * Замеряем утрилизацию ЦПУ и Памяти.
   * Подводим итоги. [Результаты тестов](./files/Результаты%20тестов.xlsx)

![](hw_08/jpa_rez.png)

Как видим во всем нужен баланс, но на продолжительных тестах - Kunderа  - начинает получать преимущество. В общем выбирать надо от задачи. 