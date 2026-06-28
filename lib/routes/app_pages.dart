import 'package:get/get.dart';
import 'app_routes.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/views/categories_view.dart';
import '../modules/categories/views/category_products_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_detail_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/checkout/views/order_confirmation_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/orders/views/order_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/addresses_view.dart';
import '../modules/profile/views/add_address_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.categoryProducts,
      page: () => const CategoryProductsView(),
      binding: CategoriesBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailView(),
      binding: ProductBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderConfirmation,
      page: () => const OrderConfirmationView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailView(),
      binding: OrdersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addresses,
      page: () => const AddressesView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addAddress,
      page: () => const AddAddressView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
