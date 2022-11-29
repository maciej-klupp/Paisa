import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/enum/box_types.dart';
import 'core/enum/card_type.dart';
import 'core/enum/debt_type.dart';
import 'core/enum/transaction.dart';
import 'data/accounts/data_sources/account_local_data_source.dart';
import 'data/accounts/data_sources/account_local_data_source_impl.dart';
import 'data/accounts/model/account.dart';
import 'data/accounts/repository/account_repository_impl.dart';
import 'data/category/data_sources/category_local_data_source.dart';
import 'data/category/data_sources/category_local_data_source_impl.dart';
import 'data/category/model/category.dart';
import 'data/category/repository/category_repository_impl.dart';
import 'data/debt/data_sources/debt_local_data_source.dart';
import 'data/debt/data_sources/debt_local_data_source_impl.dart';
import 'data/debt/models/debt.dart';
import 'data/debt/models/transaction.dart';
import 'data/debt/repository/debt_repository_impl.dart';
import 'data/expense/data_sources/expense_manager_local_data_source.dart';
import 'data/expense/data_sources/expense_manager_local_data_source_impl.dart';
import 'data/expense/model/expense.dart';
import 'data/expense/repository/expense_repository_impl.dart';
import 'data/notification/notification_service.dart';
import 'data/settings/file_handler.dart';
import 'data/settings/settings_service.dart';
import 'domain/account/repository/account_repository.dart';
import 'domain/account/use_case/account_use_case.dart';
import 'domain/category/repository/category_repository.dart';
import 'domain/category/use_case/category_use_case.dart';
import 'domain/debt/repository/debit_repository.dart';
import 'domain/debt/use_case/debt_use_case.dart';
import 'domain/expense/repository/expense_repository.dart';
import 'domain/expense/use_case/expense_use_case.dart';
import 'presentation/accounts/bloc/accounts_bloc.dart';
import 'presentation/budget_overview/cubit/filter_date_cubit.dart';
import 'presentation/category/bloc/category_bloc.dart';
import 'presentation/debits/cubit/debts_cubit.dart';
import 'presentation/expense/bloc/expense_bloc.dart';
import 'presentation/filter_widget/cubit/filter_cubit.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/settings/bloc/settings_controller.dart';
import 'presentation/settings/cubit/user_image_cubit.dart';
import 'presentation/splash/bloc/splash_bloc.dart';
import 'presentation/summary/cubit/summary_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  await _setupHive();
  _localSources();
  //await _setupNotification();
  _setupRepository();
  _setupUseCase();
  _setupBloc();
  await _setupController();
}

Future<void> _setupNotification() async {
  final service = NotificationService();
  await service.init();
  locator.registerSingleton<NotificationService>(service);
}

Future<void> _setupController() async {
  final controller = SettingsController(
    settingsService: locator.get(),
  );
  await controller.loadSettings();
  locator.registerFactory(() => controller);
}

Future<void> _setupHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(ExpenseAdapter())
    ..registerAdapter(CategoryAdapter())
    ..registerAdapter(AccountAdapter())
    ..registerAdapter(TransactionTypeAdapter())
    ..registerAdapter(DebtAdapter())
    ..registerAdapter(DebtTypeAdapter())
    ..registerAdapter(TransactionAdapter())
    ..registerAdapter(CardTypeAdapter());

  final transactionBox =
      await Hive.openBox<Transaction>(BoxType.transactions.stringValue);
  locator.registerLazySingleton<Box<Transaction>>(() => transactionBox);

  final expenseBox = await Hive.openBox<Expense>(BoxType.expense.stringValue);
  locator.registerLazySingleton<Box<Expense>>(() => expenseBox);

  final categoryBox =
      await Hive.openBox<Category>(BoxType.category.stringValue);
  locator.registerLazySingleton<Box<Category>>(() => categoryBox);

  final accountBox = await Hive.openBox<Account>(BoxType.accounts.stringValue);
  locator.registerLazySingleton<Box<Account>>(() => accountBox);

  final debtBox = await Hive.openBox<Debt>(BoxType.debts.stringValue);
  locator.registerLazySingleton<Box<Debt>>(() => debtBox);

  final boxDynamic = await Hive.openBox(BoxType.settings.stringValue);
  locator.registerLazySingleton<Box<dynamic>>(() => boxDynamic);
}

void _localSources() {
  locator.registerLazySingleton<ExpenseManagerLocalDataSource>(
      () => ExpenseManagerLocalDataSourceImpl());
  locator.registerLazySingleton<CategoryLocalDataSource>(() {
    return CategoryLocalDataSourceImpl();
  });
  locator.registerLazySingleton<AccountLocalDataSource>(
      () => AccountLocalDataSourceImpl());
  locator.registerLazySingleton<DebtLocalDataSource>(
      () => DebtLocalDataSourceImpl());
  locator.registerLazySingleton<SettingsService>(
      () => SettingsServiceImpl(locator.get()));
  locator.registerLazySingleton<FileHandler>(() => FileHandler());
}

void _setupRepository() {
  locator.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      dataSource: locator.get(),
    ),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      dataSources: locator.get(),
    ),
  );
  locator.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      dataSource: locator.get(),
    ),
  );
  locator.registerLazySingleton<DebtRepository>(
    () => DebtRepositoryImpl(
      dataSource: locator.get(),
    ),
  );
}

void _setupUseCase() {
  locator.registerLazySingleton(() => GetExpenseUseCase(locator.get()));
  locator.registerLazySingleton(() => DeleteExpenseUseCase(locator.get()));
  locator.registerLazySingleton(() => AddExpenseUseCase(locator.get()));
  locator.registerLazySingleton(() => GetCategoryUseCase(locator.get()));
  locator.registerLazySingleton(() => AddCategoryUseCase(locator.get()));
  locator.registerLazySingleton(() => DeleteCategoryUseCase(locator.get()));
  locator.registerLazySingleton(() => GetAccountUseCase(locator.get()));
  locator.registerLazySingleton(() => AddAccountUseCase(locator.get()));
  locator.registerLazySingleton(() => DeleteAccountUseCase(locator.get()));
  locator.registerLazySingleton(() => DebtUseCase(repository: locator.get()));
}

void _setupBloc() {
  locator.registerFactory(() => SplashBloc(
        accounts: locator.get(),
        categories: locator.get(),
        service: locator.get(),
        settings: locator.get(),
      ));
  locator.registerFactory(() => CategoryBloc(
        getCategoryUseCase: locator.get(),
        addCategoryUseCase: locator.get(),
        deleteCategoryUseCase: locator.get(),
      ));
  locator.registerFactory(() => ExpenseBloc(
        accountUseCase: locator.get(),
        expenseUseCase: locator.get(),
        addExpenseUseCase: locator.get(),
        deleteExpenseUseCase: locator.get(),
      ));
  locator.registerFactory(() => AccountsBloc(
        getAccountUseCase: locator.get(),
        addAccountUseCase: locator.get(),
        deleteAccountUseCase: locator.get(),
      ));
  locator.registerFactory(() => HomeBloc(locator.get()));
  locator.registerFactory(() => DebtsBloc(useCase: locator.get()));
  locator.registerFactory(() => SummaryCubit());
  locator.registerFactory(() => UserNameImageCubit());
  locator.registerFactory(() => FilterCubit());
  locator.registerFactory(() => FilterDateCubit());
}
