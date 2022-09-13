Запускаем Tarantool в докере
```
docker run \
  --name mytarantool \
  -d -p 3301:3301 \
  -v /data/dir/on/host:/var/lib/tarantool \
  tarantool/tarantool:latest

docker exec -i -t mytarantool console
```

Создаем спэйсы
```
balance = box.schema.space.create('balance', {if_not_exists=true});
```

Определяем поля
```
balance:format({
	{name = 'userID', type = 'string'},
	{name = 'amount', type = 'double'},
	{name = 'status', type = 'string'}
});
balance:create_index(
	'primary', {type = 'hash', parts = {'userID'}}
	);
```

Создаем функцию добавление/списание денег со счета
```
function add_money (userID, amount)
	row = box.space.balance:select{userID}
    if (row[1] == nil) then
        if (amount > 0) then
            box.space.balance:insert({userID, amount, 'active'})
        else
            box.space.balance:insert({userID, amount, 'not_active'})
        end
    else
        if (row[1][2] + amount > 0) then
            box.space.balance:update(userID, {{'+', 2, amount}, {'=', 3, 'active'}})
        else
            box.space.balance:update(userID, {{'+', 2, amount}, {'=', 3, 'not_active'}})
        end
    end    
end
```

Вставляем данные
```
ffi = require('ffi')
add_money("Ivan", ffi.cast('double', 400))
add_money("Ira", ffi.cast('double', 600))
add_money("Dima", ffi.cast('double', 300))
add_money("Katya", ffi.cast('double', 200))
```

Подключаем библиотеку
```
expirationd = require('expirationd')
```

Создаем функцию проверки баланса
```
function balance_check(args, tuple)
    rows = box.space.balance:select{}

    new_sum = tuple[2] - rows[1][2]
    new_status = 'active'
    
    if (tuple[3] == 'not_active') then  
        return false
    end
    
    if (new_sum <= 0) then
        new_status = 'not_active'
    end
    
    box.space.balance:update(tuple[1], {{'-', 2, rows[1][2]}, {'=', 3, new_status}})
    
    if new_status == 'not_active' then 
		require('http.client').new():request('GET', 'http://127.0.0.1', nil, {tuple[1]}) 
	end
    
    return false

end
```

Запуск функции
```
expirationd.run_task('balance', balance.id, balance_check)
```