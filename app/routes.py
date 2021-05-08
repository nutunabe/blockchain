from flask import render_template, flash, redirect, url_for, session
from app import app
from app.forms import AuthForm, ChangeAddrForm
from app.forms import AddEmployee, GetEmployee, EditEmployee, DeleteEmployee, AddHome, GetHome
from app.forms import NewHomeRequest, EditHomeRequest, AddOwnerRequest, ProcessRequest
from app.blockchain import Blockchain


bb = None


# ===============   WEB APP   ===============
@app.route('/')
@app.route('/index')
def index():
    if 'logged' in session:
        info = [
            {
                'key': 'Owner',
                'value': bb.getOwner()
            },
            {
                'key': 'Account address',
                'value': bb.account_address
            },
            {
                'key': 'Contract address',
                'value': bb.contract_address
            },
            {
                'key': 'Balance',
                'value': str(bb.getBalance())+' ETH'
            },
            {
                'key': 'Transaction cost',
                'value': str(bb.getPrice()/1e9)+' gwei'
            }
        ]
        return render_template("index.html",
                               title='Home',
                               addr=bb.account_address,
                               info=info)
    else:
        return redirect(url_for('auth'))


@app.route('/login', methods=['GET', 'POST'])
def auth():
    if 'logged' in session:
        return redirect(url_for('index'))
    else:
        session['logged'] = '+'
        global bb
        bb = Blockchain('0x0D10b2c2a567CdEE28130AcefEe3Ce4B29A33E66',
                        '0x76728e8A38F0A85C1ca6F26CA811caC859cf3176')
        return redirect(url_for('index'))
        # form = AuthForm()
        # if form.validate_on_submit():
        #     session['logged'] = '+'
        #     global bb
        #     bb = Blockchain(form.account_address.data,
        #                     form.contract_address.data)
        #     return redirect(url_for('index'))
        # return render_template('auth.html',  title='Sign In', form=form)


@app.route('/logout')
def session_reset():
    session.clear()
    return redirect(url_for('auth'))


@app.route('/menu')
def menu():
    if 'logged' in session:
        return render_template('menu.html', addr=bb.account_address)
    else:
        return redirect(url_for('auth'))


@app.route('/change_address', methods=['GET', 'POST'])
def change_address():
    if 'logged' in session:
        form = ChangeAddrForm()
        if form.validate_on_submit():
            acc_addr = bb.account_address
            bb = Blockchain(acc_addr,
                            form.contract_address.data)
            return redirect(url_for('index'))
        return render_template('addr_change.html', form=form)
    else:
        return redirect(url_for('auth'))


# ===============   REQUESTS   ==============
@app.route('/requests/new_home', methods=['GET', 'POST'])
def new_home_request():
    tx_hash = None
    form = NewHomeRequest()
    if form.validate_on_submit():
        tx_hash = bb.addNewHomeRequest(form.home_address.data, form.home_area.data,
                                       form.home_cost.data)
    return render_template('methods.html', addr=bb.account_address, mode='\"New home\" request', form=form, tx_hash=tx_hash)


@app.route('/requests/edit_home', methods=['GET', 'POST'])
def edit_home_request():
    tx_hash = None
    form = EditHomeRequest()
    if form.validate_on_submit():
        tx_hash = bb.addEditHomeRequest(form.home_address.data, form.home_area.data,
                                        form.home_cost.data)
    return render_template('methods.html', addr=bb.account_address, mode='\"Edit home\" request', form=form, tx_hash=tx_hash)


@app.route('/requests/add_owner', methods=['GET', 'POST'])
def add_owner_request():
    form = AddOwnerRequest()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=bb.account_address, mode='\"Add owner\" request', form=form)


@app.route('/requests/get_list', methods=['GET', 'POST'])
def get_request_list():
    data = None
    res=bb.getRequestList()
    print(res)
    return render_template('methods.html', addr=bb.account_address, mode='Requests list')

@app.route('/requests/process', methods=['GET', 'POST'])
def process_request():
    form = ProcessRequest()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=bb.account_address, mode='Process request', form=form)


# ===============   METHODS   ===============
@app.route('/methods/homes/add', methods=['GET', 'POST'])
def add_home():
    tx_hash = None
    form = AddHome()
    if form.validate_on_submit():
        tx_hash = bb.addHome(form.home_address.data, form.home_area.data,
                             form.home_cost.data)
        # return render_template('methods.html', addr=bb.account_address, tx_hash=tx_hash)
    return render_template('methods.html', addr=bb.account_address, mode='Add home', form=form, tx_hash=tx_hash)


@app.route('/methods/homes/get', methods=['GET', 'POST'])
def get_home():
    data = None
    form = GetHome()
    if form.validate_on_submit():
        res = bb.getHome(form.home_address.data)
        data = [
            {
                'key': 'Address',
                'value': res[0]
            },
            {
                'key': 'Area',
                'value': res[1]
            },
            {
                'key': 'Cost',
                'value': res[2]
            }
        ]
    return render_template('methods.html', addr=bb.account_address, result=data, mode='Get home', form=form)


@app.route('/methods/homes/get_list', methods=['GET', 'POST'])
def get_home_list():
    res = bb.getHomeList()
    data = []
    for i in res:
        row = [
            {
                'key': 'Address',
                'value': i[0]
            },
            {
                'key': 'Area',
                'value': i[1]
            },
            {
                'key': 'Cost',
                'value': i[2]
            }
        ]
        data.append(row)
    return render_template('methods.html', addr=bb.account_address, table=data, mode='Homes list')


@app.route('/methods/ownership/add', methods=['GET', 'POST'])
def add_ownership():
    x = ' . . . '
    #  . . .
    return redirect(url_for('index'))


@app.route('/methods/ownership/get', methods=['GET', 'POST'])
def get_ownership():
    data = None
    x = ' . . . '
    #  . . .
    return redirect(url_for('index'))


@app.route('/methods/employees/add', methods=['GET', 'POST'])
def add_employee():
    tx_hash = None
    form = AddEmployee()
    if form.validate_on_submit():
        tx_hash = bb.addEmployee(form.empl_addr.data, form.name.data,
                                 form.position.data, form.phone_number.data)
    return render_template('methods.html', addr=bb.account_address, mode='Add employee', form=form, tx_hash=tx_hash)


@app.route('/methods/employees/get', methods=['GET', 'POST'])
def get_employee():
    data = None
    form = GetEmployee()
    if form.validate_on_submit():
        res = bb.getEmployee(form.empl_addr.data)
        data = [
            {
                'key': 'Name',
                'value': res[0]
            },
            {
                'key': 'Position',
                'value': res[1]
            },
            {
                'key': 'Phone number',
                'value': res[2]
            }
        ]
    return render_template('methods.html', addr=bb.account_address, result=data, mode='Get employee', form=form)


@app.route('/methods/employees/edit', methods=['GET', 'POST'])
def edit_employee():
    tx_hash = None
    form = EditEmployee()
    if form.validate_on_submit():
        tx_hash = bb.editEmployee(form.empl_addr.data, form.name.data,
                                  form.position.data, form.phone_number.data)
    return render_template('methods.html', addr=bb.account_address, mode='Edit employee', form=form, tx_hash=tx_hash)


@app.route('/methods/employees/delete', methods=['GET', 'POST'])
def delete_employee():
    tx_hash = None
    form = DeleteEmployee()
    if form.validate_on_submit():
        tx_hash = bb.deleteEmployee(form.empl_addr.data)
    return render_template('methods.html', addr=bb.account_address, mode='Delete employee', form=form, tx_hash=tx_hash)
