<style>
   .seamless-group:focus-within {
      box-shadow: 0 0 0 0.05rem rgba(0, 123, 255, 0.25);
      border-radius: 0.25rem;
   }

   .seamless-group:focus-within .form-control,
   .seamless-group:focus-within .btn {
      border-color: #80bdff !important;
   }

   .seamless-group .form-control:focus {
      box-shadow: none;
      border-color: #ced4da;
   }

   #pwdVisibility {
      border-color: #ced4da;
      transition: all 0.2s;
   }

   #pwdVisibility:hover i {
      color: #333 !important;
   }
</style>


<div class="content-header">
   <div class="container">
      <div class="row mb-2">
         <div class="col-sm-6">
            <h1 class="m-0">Profile</h1>
         </div>
         <div class="col-sm-6 small">
            <ol class="breadcrumb float-sm-right">
               <li class="breadcrumb-item"><a href="#">Home</a></li>
               <li class="breadcrumb-item active">Profile</li>
            </ol>
         </div>
      </div>
   </div>
</div>

<!-- content  -->
<div class="content">
   <div class="container">
      <div class="row">
         <div class="col-md-3">
            <!-- Profile Image -->
            <div class="card card-primary card-outline">
               <div class="card-body box-profile">
                  <div class="text-center">
                     {{ image("photos/M3.png", "class": "profile-user-img img-fluid img-circle", "alt": "User
                     Avatar") }}
                  </div>

                  <h3 class="profile-username text-center">{{ session.name }}</h3>

                  <p class="text-muted text-center">{{ session.role }}</p>

                  <ul class="list-group list-group-unbordered mb-3">
                     <li class="list-group-item">
                        <b>Total Transaksi</b> <a class="float-right">{{ Helpers.number(qty_order) }}</a>
                        {# <b>Total Transaksi</b> <a class="float-right">{{ Helpers.number(total_order) }}</a> #}
                     </li>
                     <!-- {% if session.role == 'ADMIN' %}
                     <li class="list-group-item">
                        <b>Total</b> <a class="float-right">Rp 13,284,133</a>
                     </li>
                     {% endif %} -->
                  </ul>

                  <!-- <a href="#" class="btn btn-primary btn-block"><b>Follow</b></a> -->
               </div>
               <!-- /.card-body -->
            </div>
            <!-- /.card -->
            <!-- /.card -->
         </div>
         <!-- /.col -->
         <!-- formulir edit profile -->
         <div class="col-md-9">
            <div class="card card-primary card-outline">
               <div class="card-header">
                  <h3 class="card-title">Edit Profile</h3>
               </div>
               <!-- /.card-header -->
               <div class="card-body">
                  <form class="form-horizontal" action="{{ url('profile/update') }}" method="post">
                     <div class="row col-md-12">
                        <div class="col-md-6">
                           <div class="form-group">
                              <label for="inputName">Name</label>
                              <input type="hidden" name="id" id="id" value="{{ session.id }}">
                              <input type="text" class="form-control form-control-sm" id="inputName" name="name"
                                 placeholder="Name" value="{{ session.name }}" required>
                              <span class="text-danger small" id="nameError"></span>
                           </div>
                           <div class="form-group">
                              <label for="inputUsername">Username</label>
                              <input type="text" class="form-control form-control-sm" id="inputUsername" name="username"
                                 placeholder="Username" value="{{ session.username }}" required>
                              <span class="text-danger small" id="usernameError"></span>
                           </div>
                        </div>
                        <div class="col-md-6">
                           <div class="form-group">
                              <label for="inputRole">Role</label>
                              <input type="text" class="form-control form-control-sm" id="inputName" placeholder="Name"
                                 value="{{ session.role }}" readonly>
                           </div>
                           <div class="form-group">
                              <label for="inputPassword">New Password</label>
                              <div class="input-group input-group-sm seamless-group">
                                 <input type="password" class="form-control border-right-0" id="inputPassword"
                                    name="password" placeholder="Password">
                                 <div class="input-group-append">
                                    <button type="button" id="pwdVisibility"
                                       class="btn border-left-0 shadow-none">
                                       <i class="fas fa-eye text-muted" id="eyeIcon"></i>
                                    </button>
                                 </div>
                              </div>
                           </div>

                        </div>
                        <div class="col-md-12 mt-2 text-right">
                           <button type="submit" class="btn btn-sm btn-primary">Submit</button>
                        </div>
                     </div>
                  </form>
               </div>
               <!-- /.card-body -->
            </div>
            <!-- /.card -->
         </div>
         <!-- /.col -->
      </div>
   </div>
</div>

<script>
   // toggle password btn visibility
   $(document).ready(function () {
      $('#pwdVisibility').on('click', function () {
         var input = $('#inputPassword');
         var icon = $('#eyeIcon');

         if (input.attr('type') == 'password') {
            input.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
         } else {
            input.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
         }
      });
   });

   // tambahkan validation menggunakan jQuery untuk input yang required
   $(document).ready(function () {
      $('#inputName').on('change', function () {
         if ($(this).val() == '') {
            $(this).addClass('is-invalid');
            $('#nameError').text('Name is required');
         } else {
            $(this).removeClass('is-invalid');
            $('#nameError').text('');
         }
      });
      $('#inputUsername').on('change', function () {
         if ($(this).val() == '') {
            $(this).addClass('is-invalid');
            $('#usernameError').text('Username is required');
         } else {
            $(this).removeClass('is-invalid');
            $('#usernameError').text('');
         }
      });
   });
</script>