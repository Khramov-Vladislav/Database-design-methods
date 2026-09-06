package main

import (
	"database/sql"
	"fmt"
	"log"
	"math/rand"
	"time"

	"github.com/brianvoe/gofakeit/v6"
	_ "github.com/lib/pq"
)

const (
	buildingsCount = 20
	studentsCount  = 5000
)

func main() {
	connStr := "host=localhost port=5432 user=postgres password=postgres dbname=dormitory sslmode=disable"

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	gofakeit.Seed(time.Now().UnixNano())

	for {
		fmt.Println("\n====== МЕНЮ ======")
		fmt.Println("1. Загрузить данные")
		fmt.Println("2. Очистить таблицы")
		fmt.Println("3. Обновить данные")
		fmt.Println("0. Выход")
		fmt.Print("Выбор: ")

		var choice int
		fmt.Scan(&choice)

		switch choice {
		case 1:
			loadData(db)
		case 2:
			clearTables(db)
		case 3:
			clearTables(db)
			loadData(db)
		case 0:
			fmt.Println("Выход...")
			return
		default:
			fmt.Println("Неверный выбор")
		}
	}
}

func loadData(db *sql.DB) {
	fmt.Println("Генерация данных...")

	insertRoomTypes(db)
	insertPaymentMethods(db)

	buildingIDs := insertBuildings(db)
	roomIDs := insertRooms(db, buildingIDs)
	placeIDs := insertPlaces(db, roomIDs)

	studentIDs := insertStudents(db)
	employeeIDs := insertEmployees(db)

	settlementIDs := insertSettlements(db, studentIDs, employeeIDs, placeIDs)

	insertPayments(db, settlementIDs)
	insertReviews(db, settlementIDs)

	fmt.Println("Данные загружены")
}

func clearTables(db *sql.DB) {
	fmt.Println("Очистка таблиц...")

	tables := []string{
		"review",
		"payment",
		"settlement",
		"place",
		"room",
		"building",
		"student",
		"employee",
		"payment_method",
		"room_type",
	}

	for _, t := range tables {
		if _, err := db.Exec("TRUNCATE TABLE " + t + " RESTART IDENTITY CASCADE"); err != nil {
			log.Fatalf("Ошибка очистки %s: %v", t, err)
		}
	}

	fmt.Println("Таблицы очищены")
}

func insertRoomTypes(db *sql.DB) {
	types := []string{"квартирный", "блочный", "коридорный", "гостиничный"}
	for _, t := range types {
		if _, err := db.Exec("INSERT INTO room_type(type_name) VALUES ($1)", t); err != nil {
			log.Fatalf("Ошибка вставки данных %s: %v", t, err)
		}
	}
}

func insertPaymentMethods(db *sql.DB) {
	methods := []string{"карта", "онлайн", "наличка"}
	for _, m := range methods {
		if _, err := db.Exec("INSERT INTO payment_method(method_name) VALUES ($1)", m); err != nil {
			log.Fatalf("Ошибка вставки данных %s: %v", m, err)
		}
	}
}

func insertBuildings(db *sql.DB) []int {
	var ids []int
	for range buildingsCount {
		var id int
		if err := db.QueryRow(
			"INSERT INTO building(building_address) VALUES ($1) RETURNING building_id",
			gofakeit.Address().Address,
		).Scan(&id); err != nil {
			log.Fatal(err)
		}
		ids = append(ids, id)
	}
	return ids
}

func insertRooms(db *sql.DB, buildingIDs []int) []int {
	var ids []int

	for _, bID := range buildingIDs {
		roomCount := rand.Intn(51) + 50

		for range roomCount {
			var id int
			roomType := rand.Intn(4) + 1

			if err := db.QueryRow(
				"INSERT INTO room(building_id, room_type_id) VALUES ($1, $2) RETURNING room_id",
				bID, roomType,
			).Scan(&id); err != nil {
				log.Fatal(err)
			}

			ids = append(ids, id)
		}
	}
	return ids
}

func insertPlaces(db *sql.DB, roomIDs []int) []int {
	var ids []int

	for _, rID := range roomIDs {
		count := rand.Intn(5) + 1

		for range count {
			var id int
			if err := db.QueryRow(
				"INSERT INTO place(level, room_id) VALUES ($1, $2) RETURNING place_id",
				rand.Intn(5)+1,
				rID,
			).Scan(&id); err != nil {
				log.Fatal(err)
			}

			ids = append(ids, id)
		}
	}
	return ids
}

func insertStudents(db *sql.DB) []int {
	var ids []int

	for range studentsCount {
		var id int
		if err := db.QueryRow(
			`INSERT INTO student(last_name, first_name, middle_name, passport_data)
			 VALUES ($1,$2,$3,$4) RETURNING student_id`,
			gofakeit.LastName(),
			gofakeit.FirstName(),
			gofakeit.FirstName(),
			gofakeit.DigitN(10),
		).Scan(&id); err != nil {
			log.Fatal(err)
		}

		ids = append(ids, id)
	}
	return ids
}

func insertEmployees(db *sql.DB) []int {
	count := []int{50, 100}[rand.Intn(2)]
	var ids []int

	for range count {
		var id int
		if err := db.QueryRow(
			`INSERT INTO employee(last_name, first_name, middle_name, passport_data, position)
			 VALUES ($1,$2,$3,$4,$5) RETURNING employee_id`,
			gofakeit.LastName(),
			gofakeit.FirstName(),
			gofakeit.FirstName(),
			gofakeit.DigitN(10),
			gofakeit.JobTitle(),
		).Scan(&id); err != nil {
			log.Fatal(err)
		}

		ids = append(ids, id)
	}
	return ids
}

func insertSettlements(db *sql.DB, students, employees, places []int) []int {
	var ids []int

	for _, student := range students {
		count := rand.Intn(6) + 5

		for range count {
			var id int

			moveIn := gofakeit.DateRange(time.Now().AddDate(-5, 0, 0), time.Now())
			moveOut := moveIn.AddDate(0, rand.Intn(12), 0)

			if err := db.QueryRow(
				`INSERT INTO settlement(student_id, employee_id, place_id, move_in_date, move_out_date)
				 VALUES ($1,$2,$3,$4,$5) RETURNING settlement_id`,
				student,
				employees[rand.Intn(len(employees))],
				places[rand.Intn(len(places))],
				moveIn,
				moveOut,
			).Scan(&id); err != nil {
				log.Fatal(err)
			}

			ids = append(ids, id)
		}
	}
	return ids
}

func insertPayments(db *sql.DB, settlements []int) {
	for _, s := range settlements {
		count := rand.Intn(6) + 10

		for range count {
			if _, err := db.Exec(
				`INSERT INTO payment(settlement_id, payment_method_id, payment_amount, payment_date)
				 VALUES ($1,$2,$3,$4)`,
				s,
				rand.Intn(3)+1,
				gofakeit.Price(100, 1000),
				gofakeit.Date(),
			); err != nil {
				log.Fatal(err)
			}
		}
	}
}

func insertReviews(db *sql.DB, settlements []int) {
	for _, s := range settlements {
		count := rand.Intn(11)

		for range count {
			if _, err := db.Exec(
				`INSERT INTO review(settlement_id, comment, rating, review_date)
				 VALUES ($1,$2,$3,$4)`,
				s,
				gofakeit.Sentence(10),
				rand.Intn(5)+1,
				gofakeit.Date(),
			); err != nil {
				log.Fatal(err)
			}
		}
	}
}
